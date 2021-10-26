# Helm Chart for MEP Spark History Server

[Spark History Server](https://spark.apache.org/docs/latest/monitoring.html#viewing-after-the-fact) provides a web UI for completed and running Spark applications. The supported storage backends are MaprFS and PersistentVolumeClaim (PVC)

## Installing the Chart

Note that this chart requires ECP tenant operator to be installed and Tenant CR applied in the tenant namespace.

### Install command
`helm install spark-hs ./spark-hs-chart -n sampletenant`
This will create the helm chart in the `sampletenant` namespace.  This will create Spark history server with v3.1.2  

To install spark history server V2.4.7 use the flags: <br>
`--set image.imageName=spark-hs-2.4.7 --set image.tag=202110061237C --set sparkVersion=spark-2.4.7`

#### Installing in a non DF Tenant
To install the helm chart in tenant type 'none' Namespace use the flag:  
`--set tenantIsUnsecure=true --set eventlogstorage.kind=pvc --set eventlogstorage.pvcname=spark-hs-pvc`  
Please note that if you are using an existing PVC, the pvc should exist in the same namespace.

##### Using custom keystore
To use a custom keystore, you'll need to create a secret with that keystore file in tenant namespace manually.
The secret should have keystore file stored under a particular key, e.g. "ssl_keystore".
Spark HS SSL configuration options can be passed to spark-hs in secure manner using 'extra_configs' section, 
as shown in example below. Assuming that the secret name is "spark-ssl-secret", and the keystore key name in secret is 
"ssl_keystore", and passwords are "examplepass", update values.yaml like this:
```yaml
spark_ssl:
  use_custom_keystore: true
  ssl_secret_name: "spark-ssl-secret"
  secret_mount_path: /var/spark

spark_extra_configs: |
  spark.ssl.historyServer.enabled           true
  spark.ssl.historyServer.keyStore          /var/spark/ssl_keystore
  spark.ssl.historyServer.keyStorePassword  examplepass
  spark.ssl.historyServer.keyPassword       examplepass
  spark.ssl.historyServer.protocol          TLSv1.2
  spark.ssl.historyServer.keyStoreType      PKCS12
```

##### Using S3 for storing logs
Alternatively you can create history server with existing s3 buckets for events log storage. To use this you can add the following flags to install command:
```
--set tenantIsUnsecure=true \
--set eventlogstorage.kind=s3 \
--set eventlogstorage.s3Endpoint=http://s3host:9000 \
--set eventlogstorage.s3path=s3a://bucket/folder \
--set eventlogstorage.s3AccessKey=AccessKey \
--set eventlogstorage.s3SecretKey=secretKey
```
Also, you can pass S3 credentials in secure way using "extra_configs" feature like this:
```yaml
spark_extra_configs: |
  spark.hadoop.fs.s3a.access.key: [access_key]
  spark.hadoop.fs.s3a.secret.key: [secret_key]
```

### Viewing the UI
After the chart is successfully installed, a message would be printed out to the console with details about how to access the UI.

## Uninstalling the Chart
Uninstall spark history server deployment named "spark-hs" from 'sampletenant' tenant
```
helm uninstall spark-hs -n sampletenant
```
Please note that this won't delete the PVC in case you are using an existing PVC. PVC will have to be manually deleted.
