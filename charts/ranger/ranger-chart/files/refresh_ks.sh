#!/bin/bash

ns="${1:-ranger}"

ADMIN_TRUSTSTORE_SECRET_NAME="yarik-admin-truststore"
UGSYNC_TRUSTSTORE_SECRET_NAME="yarik-ugsync-truststore"
ADMIN_TRUSTSTORE_PASS="yarikadmin"
UGSYNC_TRUSTSTORE_PASS="yarikugsync"

mkdir -p ranger-chart/files/ssl/ks ranger-chart/files/ssl/certs

find ./ranger-chart/files/ssl/ -type f -delete
kubectl -n $ns delete secret ${UGSYNC_TRUSTSTORE_SECRET_NAME}
kubectl -n $ns delete secret ${ADMIN_TRUSTSTORE_SECRET_NAME}

echo | openssl s_client -connect example.com:636 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ./ranger-chart/files/ssl/certs/ldap.crt

keytool -importcert -file ./ranger-chart/files/ssl/certs/ldap.crt -keystore ./ranger-chart/files/ssl/ks/ugsync_truststore.jks -alias "ldap-CA" -storepass ${UGSYNC_TRUSTSTORE_PASS}  -noprompt
keytool -importcert -file ./ranger-chart/files/ssl/certs/ldap.crt -keystore ./ranger-chart/files/ssl/ks/admin_truststore.jks -alias "ldap-CA" -storepass ${ADMIN_TRUSTSTORE_PASS} -noprompt
kubectl -n $ns create secret generic ${UGSYNC_TRUSTSTORE_SECRET_NAME} --from-file=ugsync_truststore.jks=./ranger-chart/files/ssl/ks/ugsync_truststore.jks
kubectl -n $ns create secret generic ${ADMIN_TRUSTSTORE_SECRET_NAME} --from-file=admin_truststore.jks=./ranger-chart/files/ssl/ks/admin_truststore.jks

