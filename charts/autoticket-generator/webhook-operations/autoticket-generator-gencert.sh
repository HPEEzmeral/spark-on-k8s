#!/usr/bin/env bash

DIRECTORY="services"
AUTOTICKET_GENERATOR_SERVICE="autoticket-generator-svc"
KEY_SIZE=2048
KEY_FILENAME=$DIRECTORY/$AUTOTICKET_GENERATOR_SERVICE.key
CONFIG_FILENAME=$DIRECTORY/$AUTOTICKET_GENERATOR_SERVICE.config
CERT_FILENAME=$DIRECTORY/$AUTOTICKET_GENERATOR_SERVICE.csr
CSRCERT_FILENAME=$DIRECTORY/$AUTOTICKET_GENERATOR_SERVICE.csrcert

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
CN                     = system:node:autoticket-generator-svc
emailAddress           = support@hpe.com
[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[ alt_names ]
DNS.1 = autoticket-generator-svc
DNS.2 = autoticket-generator-svc.hpe-system
DNS.3 = autoticket-generator-svc.hpe-system.svc
EOF


update_replace_yaml() {
  data_bytes=`cat $CERT_FILENAME | base64 | tr -d '\n'`
  sed -i 's,{autoticket-csr-data},'$data_bytes',g' autoticket-generator-csr.yaml
}

genservicecert() {
  echo "Generating Auto Ticket Generator Service Cert..."
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
  kubectl delete -f autoticket-generator-csr.yaml
  # create new csr
  kubectl apply -f autoticket-generator-csr.yaml

  echo "Approving the Auto Ticket Generator Service CSR..."
  kubectl certificate approve autoticket-generator-svc.hpe-system

  # verify CSR has been created

  for (( i=0; i<3; ++i)); do

    encoded_server_cert=`kubectl get csr autoticket-generator-svc.hpe-system -o jsonpath={.status.certificate}`

    if [ -z "$encoded_server_cert" ]
    then
      echo "After approving the Auto Ticket Generator Service CSR, the signed certificate did not appear on the resource."
    elif [ $encoded_server_cert == "<no response>" ]
    then
      echo "After approving the Auto Ticket Generator Service CSR, was not able to get a response"
    fi

  done

  if [ -z "$encoded_server_cert" ]
  then
    echo "After approving the Auto Ticket Generator Service CSR, the signed certificate did not appear on the resource after 3 tries"
  elif [ $encoded_server_cert == "<no response>" ]
  then
    echo "After approving the Auto Ticket Generator Service CSR, was not able to get a response"
  fi

  echo "Verified the Auto Ticket Generator Service CSR was signed."

  decoded_cert=`echo "$encoded_server_cert" | base64 --decode`
  echo "$decoded_cert" > $CSRCERT_FILENAME

  sed -i 's,{autoticket-servercert-encoded},'$encoded_server_cert',g' autoticket-generator-mwhconfig.yaml
  sed -i 's,{autoticket-servercert-encoded},'$encoded_server_cert',g' autoticket-generator-vwhconfig.yaml

}

create_autoticket_generator_secret() {
  kubectl create secret generic autoticket-generator-certs -n hpe-system --from-file=key.pem=$1 --from-file=cert.pem=$2
}

delete_autoticket_generator_secret() {
  kubectl delete secret autoticket-generator-certs -n hpe-system --ignore-not-found
}

run_install() {

  genservicecert
  update_replace_yaml

  kubectl apply -f autoticket-generator-csr.yaml

  genk8csr

  echo "Deleting previously created Auto Ticket Generator Service certs secret..."
  delete_autoticket_generator_secret

  echo "Creating Auto Ticket Generator Service Certs Secret ..."

  create_autoticket_generator_secret "$KEY_FILENAME" "$CSRCERT_FILENAME"

  echo "Created Auto Ticket Generator Service certs secret."

  echo "Creating mutating webhook"
  kubectl apply -f autoticket-generator-mwhconfig.yaml

  echo "Creating validating webhook"
  kubectl apply -f autoticket-generator-vwhconfig.yaml

}

run_install