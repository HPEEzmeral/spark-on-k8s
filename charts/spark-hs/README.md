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

### Viewing the UI
After the chart is successfully installed, a message would be printed out to the console with details about how to access the UI.

## Uninstalling the Chart
Uninstall spark history server deployment named "spark-hs" from 'sampletenant' tenant
```
helm uninstall spark-hs -n sampletenant
```
Please note that this won't delete the PVC in case you are using an existing PVC. PVC will have to be manually deleted.
