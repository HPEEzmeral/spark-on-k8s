#!/usr/bin/env bash

DIRECTORY="services"
TENANT_VALIDATOR_SERVICE="tenant-validator-svc"
KEY_SIZE=2048
KEY_FILENAME=$DIRECTORY/$TENANT_VALIDATOR_SERVICE.key
CONFIG_FILENAME=$DIRECTORY/$TENANT_VALIDATOR_SERVICE.config
CERT_FILENAME=$DIRECTORY/$TENANT_VALIDATOR_SERVICE.csr
CSRCERT_FILENAME=$DIRECTORY/$TENANT_VALIDATOR_SERVICE.csrcert

read -r -d '' OPENSSL_CONFIG_TEMPLATE <<'EOF'
prompt = no
distinguished_name = req_distinguished_name
req_extensions = v3_req
[ req_distinguished_name ]
C                      = US
ST                     = CO
L                      = Fort Collins
O                      = system:nodes
OU                     = HCP
CN                     = system:node:tenant-validator-svc
emailAddress           = support@hpe.com
[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[ alt_names ]
DNS.1 = tenant-validator-svc
DNS.2 = tenant-validator-svc.hpe-system
DNS.3 = tenant-validator-svc.hpe-system.svc
EOF


update_replace_yaml() {
  data_bytes=`cat $CERT_FILENAME | base64 | tr -d '\n'`
  sed -i 's,{tenant-validator-csr},'$data_bytes',g' tenantvalidator-csr.yaml
}

genservicecert() {
  echo "Generating Tenant Validator Service Cert..."
  echo "Generating new self-signed cert..."

  #create directory if not already present
  if [ ! -d "$DIRECTORY" ]; then
    mkdir $DIRECTORY
  fi

  if [ ! -f "$KEY_FILENAME" ]; then
    openssl genrsa -out $KEY_FILENAME $KEY_SIZE
  fi

  echo "$OPENSSL_CONFIG_TEMPLATE" > $CONFIG_FILENAME
  openssl req -new -key $KEY_FILENAME -out $CERT_FILENAME -config $CONFIG_FILENAME
}

genk8csr() {
  # clean-up any previously created CSR for our service. Ignore errors if not present.
  kubectl delete -f tenantvalidator-csr.yaml
  # create new csr
  kubectl apply -f tenantvalidator-csr.yaml

  echo "Approving the Tenant Validator Service CSR..."
  kubectl certificate approve tenant-validator-svc.hpe-system

  # verify CSR has been created

  for (( i=0; i<3; ++i)); do

    encoded_server_cert=`kubectl get csr tenant-validator-svc.hpe-system -o jsonpath={.status.certificate}`

    if [ -z "$encoded_server_cert" ]
    then
      echo "After approving the Tenant Validator Service CSR, the signed certificate did not appear on the resource."
    elif [ $encoded_server_cert == "<no response>" ]
    then
      echo "After approving the Tenant Validator Service CSR, was not able to get a response"
    fi

  done

  if [ -z "$encoded_server_cert" ]
  then
    echo "After approving the Tenant Validator Service CSR, the signed certificate did not appear on the resource after 3 tries"
  elif [ $encoded_server_cert == "<no response>" ]
  then
    echo "After approving the Tenant Validator Service CSR, was not able to get a response"
  fi

  echo "Verified the Tenant Validator Service CSR was signed."

  decoded_cert=`echo "$encoded_server_cert" | base64 --decode`
  echo "$decoded_cert" > $CSRCERT_FILENAME

  sed -i 's,{tenantvalidator-servercert-encoded},'$encoded_server_cert',g' tenantvalidator-mwhconfig.yaml
  sed -i 's,{tenantvalidator-servercert-encoded},'$encoded_server_cert',g' tenantvalidator-vwhconfig.yaml

}

create_tenantvalidator_secret() {
  kubectl create secret generic tenant-validator-certs -n hpe-system --from-file=key.pem=$1 --from-file=cert.pem=$2
}

delete_tenantvalidator_secret() {
  kubectl delete secret tenant-validator-certs -n hpe-system --ignore-not-found
}

run_install() {

  genservicecert
  update_replace_yaml

  kubectl apply -f tenantvalidator-csr.yaml

  genk8csr

   echo "Deleting previously created Tenant Validator Service certs secret..."
   delete_tenantvalidator_secret

  echo "Creating Tenant Validator Service Certs Secret ..."

  create_tenantvalidator_secret "$KEY_FILENAME" "$CSRCERT_FILENAME"

  echo "Created Tenant Validator Service certs secret."

  echo "Creating mutating webhook"
  kubectl apply -f tenantvalidator-mwhconfig.yaml

  echo "Creating validating webhook"
  kubectl apply -f tenantvalidator-vwhconfig.yaml

}

run_install