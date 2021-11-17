# Helm Chart for Livy default version 0.7.0

[Livy](https://livy.incubator.apache.org/) provides a REST API for Spark.

## Installing the Chart

Note that this chart requires ECP tenant operator to be installed and Tenant CR applied in the tenant namespace.

### Install command with default version
```sh
helm dependency update ./livy-chart
helm install livy ./livy-chart -n sampletenant
```

This will create the helm chart in the `sampletenant` namespace. This will create livy-0.7.0 with support for spark v3.1.2  
Please note:
* This assumes you are installing in an 'internal' or 'external' Tenant Namespace. Installing livy chart in a non tenant namespace can cause error because of missing configmaps and secrets.
* If you are using PVC, the pvc should exist in the same namespace.
* Integrations for Spark History server and metastore can be customized in the values.yaml file.

### Install with different version
To install livy-0.5.0 with spark-2.4.7 support use the flags:  
`--set image.imageName=livy-0.5.0 --set image.tag=202106291513C --set sparkVersion=spark-2.4.7 --set sessionRecovery.kind=zookeeper --set deImage=spark-2.4.7:202106220630P141`

#### Installing in a non DF Tenant
To install the helm chart in tenant type 'none' Namespace use the flag:  
`--set tenantIsUnsecure=true `

##### Using custom keystore
To use a custom keystore, you'll need to create a secret with that keystore file in tenant namespace manually.
The secret should have keystore file stored under a particular key, e.g. "ssl_keystore".
Livy SSL configuration options can be passed to Livy in secure manner using `extraConfigs` section, 
as shown in example below. Assuming that the secret name is "livy-ssl-secret", and the keystore key name in secret is 
"ssl_keystore", and passwords are "examplepass", update values.yaml like this:
```yaml
livySsl:
  useCustomKeystore: true
  sslSecretName: "livy-ssl-secret"
  secretMountPath: /var/livy

extraConfigs:
  livy.conf: |
    livy.keystore = /var/livy/ssl_keystore
    livy.keystore.password = examplepass
    livy.key-password = examplepass
```

## Uninstalling the Chart
`helm delete livy -n sampletenant`

Please note that this won't delete the PVC in case you are using a PVC. PVC will have to be manually deleted.
