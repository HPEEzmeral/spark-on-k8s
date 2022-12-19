# EEP Ranger helm chart
Here you can find helm chart for EEP Ranger deployment on k8s environment. Main configuration files are:
+ [values.yaml](https://github.com/HPEEzmeral/spark-on-k8s/blob/ranger/charts/ranger/ranger-chart/values.yaml)
+ [install.properties (admin)](https://github.com/HPEEzmeral/spark-on-k8s/blob/ranger/charts/ranger/ranger-chart/templates/ranger/configmap-ranger-admin.yaml)
+ [install.properties (usersync)](https://github.com/HPEEzmeral/spark-on-k8s/blob/ranger/charts/ranger/ranger-chart/templates/usersync/configmap-usersync.yaml)

**TODO**: change configmaps to secrets. Probably file links will also be changed.

## MySQL: embedded or shared
By default Ranger will deploy its own mysql inside its chart and will use it to store data. But you have an option to
use existing (shared) MySQL DB instead of deploying embedded one. To do that:
1. set `dataStore.embeddedMysql`: false
2. provide MySQL server address in `dataStore.service.clusterIp.fullName`

In both embedded and shared cases DB creds are configured in:
+ `dataStore.rootPasswd`
+ `dataStore.user`
+ `dataStore.passwd`

## PV type: DF or NFS (only for embedded MySQL)
**Note**: if you chose to use shared MySQL, you may skip this step.

You have two options of which persistent provider to use:
1. DataFabric storage class
2. NFS server (provided by you)
### Configuring with DF
You can determine proper storage class name by issuing:
```agsl
kubectl get sc | grep com.mapr.csi-kdf | tr -s ' ' | cut -f 1 -d ' ' | tail +1
```
1. Please set `dataStore.storage.isNfs`: false
2. And provide your storage class in `dataStore.storage.storageClassName`
### Configuring with NFS
**Note**: preparing NFS server side is done by your side, Ranger assumes it is already prepared.
You would need such shared directories:
```agsl
/nfs/ranger/mysql-pv
/nfs/ezsql/masterdata/pv0
/nfs/ezsql/masterdata/pv2
/nfs/ezsql/masterdata/pv1
/nfs/ezsql/masterdata/pv3
/nfs/ezsql/masterdata/pv4
/nfs/ezsql/workerdata/pv0
/nfs/ezsql/workerdata/pv1
/nfs/ezsql/workerdata/pv2
/nfs/ezsql/workerdata/pv3
/nfs/ezsql/workerdata/pv4
/nfs/ezsql/common-catalogs
/nfs/ezsql/mysql-pv
```
With following ownership and permissions:
```agsl
chown nfsnobody:nfsnobody -R /nfs && chmod 777 -R /nfs
```
1. Please set `dataStore.storage.isNfs`: true
2. And provide your NFS server IP in `dataStore.storage.serverIp`
### Defaults
Default behaviour is configured to use DF assuming that your DF cluster name is 
`cluster.qa.lab`

## Usersync 
Ranger Usersync service deployment is optional. To enable it, please set
`usersync.deploymentEnabled`: true.
You can configure Usersync to source users & groups in `usersync.sync_source` part.

## Admin authentication
You can configure Admin authentication in `ranger.user_authentication` section.

## Cleanup and install
Run this script to do full cleanup:
```agsl
./ranger-chart/files/full-cleanup.sh
```
and run this script to start fresh installation:
```agsl
./ranger-chart/files/fresh-install-ranger.sh
```
## Using custom truststores
You might want to make ranger use certificates provided by you from
your custom truststore. For example, to securely communicate with LDAPS server. To do that, you should perform these steps:
1. Prepare your server's certificate. You may also use this command to retrieve certificate if you know server address:
```agsl
echo | openssl s_client -connect example.com:636 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ./ranger-chart/files/ssl/certs/ldap.crt
```
2. Create truststores for admin and usersync and import the certificate there, f.e.:
```agsl
keytool -importcert -file ./ranger-chart/files/ssl/certs/ldap.crt -keystore ./ranger-chart/files/ssl/ks/ugsync_truststore.jks -alias "ldap-CA" -storepass ${UGSYNC_TRUSTSTORE_PASS}  -noprompt
keytool -importcert -file ./ranger-chart/files/ssl/certs/ldap.crt -keystore ./ranger-chart/files/ssl/ks/admin_truststore.jks -alias "ldap-CA" -storepass ${ADMIN_TRUSTSTORE_PASS} -noprompt
```
3. Create secrets in ranger's namespace with keys `ugsync_truststore.jks` for usersync and `admin_truststore.jks` for admin
and put respective truststores there:
```agsl
kubectl -n $ns create secret generic ${UGSYNC_TRUSTSTORE_SECRET_NAME} --from-file=ugsync_truststore.jks=./ranger-chart/files/ssl/ks/ugsync_truststore.jks
kubectl -n $ns create secret generic ${ADMIN_TRUSTSTORE_SECRET_NAME} --from-file=admin_truststore.jks=./ranger-chart/files/ssl/ks/admin_truststore.jks
```
4. Enable custom truststore flag and provide secret names and passwords for both admin and usersync:
```agsl
#admin
  ssl:
    use_custom_truststore: true
    truststore_password: "adminpass"
    truststore_secret_name: my-admin-truststore
#usersync
  ssl:
    use_custom_truststore: true
    truststore_password: "ugsyncpass"
    truststore_secret_name: my-ugsync-truststore
```
**Note**: example of doing 1-3 steps can be found in `ranger-chart/files/refresh_ks.sh` script.