# Helm Chart for Livy default version 0.8.0.0

[Livy](https://livy.incubator.apache.org/) provides a REST API for Spark.

## Installing the Chart

Note that this chart requires ECP tenant operator to be installed and Tenant CR applied in the tenant namespace.

### Install command with default version
```sh
helm dependency update ./livy-chart
helm install livy ./livy-chart -n sampletenant
```

This will create the helm chart in the `sampletenant` namespace. This will create livy-0.7.0 with support for spark v3.3.1  
Please note:
* This assumes you are installing in an 'internal' or 'external' Tenant Namespace. Installing livy chart in a non tenant namespace can cause error because of missing configmaps and secrets.
* If you are using PVC, the pvc should exist in the same namespace.
* Integrations for Spark History server and metastore can be customized in the values.yaml file.

### Install with spark-2.4.7 version
To install Livy with spark-2.4.7 support use the flags:  
`--set image.imageName=livy-0.8.0.0-2.4.7 --set image.tag=202311231143R --set livyVersion=0.8.0.0 --set deImage=spark-2.4.7:202311231143R`

#### Installing in a non DF Tenant
To install the helm chart in tenant type 'none' Namespace use the flag:  
`--set tenantIsUnsecure=true`

## Uninstalling the Chart
`helm uninstall livy -n sampletenant`

**Note:** If you are using PVC, running the `helm uninstall` command won't delete the PVC. You must manually delete the PVC.

## Configuring Livy

Set the custom options for the `livy.conf`, `livy-client.conf` and `spark-defaults.conf` file in the `extraConfigs` section of the `values.yaml` file.  
Content of this section would be mounted into the Livy as a K8s Secret.  
The content of `livy.conf`, `livy-client.conf` and `spark-defaults.conf` subsections of `extraConfigs` section would be appended to the corresponding configuration files.

### Using custom keystore
To use a custom keystore to enable HTTPS for the Livy UI, you'll need to manually create a secret with that keystore file in the tenant namespace.

Livy SSL configuration options can be securely passed to Livy using the `extraConfigs` section.  
For example: If the secret name is `livy-ssl-secret`, the keystore key name in the secret is `ssl_keystore` and the password is `examplepass`, update `values.yaml` like this:

```yaml
livySsl:
  enable: true
  sslSecretName: "livy-ssl-secret"
  secretMountPath: /var/livy

extraConfigs:
  livy.conf: |
    livy.keystore = /var/livy/ssl_keystore
    livy.keystore.password = examplepass
    livy.key-password = examplepass
```

### Integration with Spark History Server

To enable integration with Spark History Server, set the `integrate` option of the `sparkHistoryServer` section to `true` and configure the event log directory.  
Event log directory can be either in PVC or in MapR-FS.

#### Using PVC as storage of Event Log

To configure the integration of Livy Spark Sessions with Spark History Server using PVC, you need to create PVC and specify `pvcName` with `eventsDir` options in the `sparkHistoryServer` section.

`eventsDir` option allows configuring the path where PVC would be mounted into Livy Spark Session pods.

Example:
```yaml
sparkHistoryServer:
  integrate: true
  pvcName: "my-shs-pvc"
  eventsDir: "/opt/mapr/spark/eventsdir"
```

#### Using MapR-FS as storage of Event Log

To configure the integration of Livy Spark Sessions with Spark History Server using MapR-FS as storage for Event Log, you need to specify a location of event log directory in MapR-FS with `eventsDir` option of the `sparkHistoryServer` section.  
Also, the value of `pvcName` option should remain empty.

Example:
```yaml
sparkHistoryServer:
  integrate: true
  pvcName: ""
  eventsDir: "maprfs:///apps/spark/sampletenant"
```

### Integration with Metastore

To configure the integration of Livy Spark Sessions with Metastore as table storage for Spark SQL, you need to set the `hiveSiteSource` option with the ConfigMap that contains `hive-site.xml`.

Example:
```yaml
hiveSiteSource: "hivesite-cm"
```

### Integration with S3

To integrate Livy Spark Sessions with S3, you need to set the following Spark options:

```
spark.hadoop.fs.s3a.access.key <access-key>
spark.hadoop.fs.s3a.secret.key <secret-key>
spark.hadoop.fs.s3a.path.style.access true
spark.hadoop.fs.s3a.impl org.apache.hadoop.fs.s3a.S3AFileSystem
spark.driver.extraJavaOptions -Dcom.amazonaws.sdk.disableCertChecking=true
spark.executor.extraJavaOptions -Dcom.amazonaws.sdk.disableCertChecking=true
```

Additionally, you can specify the location of S3-compatible server:
```
spark.hadoop.fs.s3a.endpoint http://<ip>:<port>
```

Also, when your S3 endpoint not encrypted with SSL, you need to specify the following option:
```
spark.hadoop.fs.s3a.connection.ssl.enabled false
```

The following options are needed to be specified in case your K8s cluster is behind the proxy server:
```]
spark.hadoop.fs.s3a.proxy.host <proxy-host>
spark.hadoop.fs.s3a.proxy.port <proxy-port>
```

Integration of Livy Spark Sessions with S3 can be enabled in the following methods:  
* Globally, for all sessions created by the Livy installation
* On session creation

#### Serverwide integration

To enable S3 integration for all sessions in the scope of one Livy installation, you need to add those options in the `spark-defautls.conf` part of the `extraConfigs` section of `values.yaml`.

Example:
```yaml
extraConfigs:
  spark-defaults.conf: |
    spark.hadoop.fs.s3a.access.key <access-key>
    spark.hadoop.fs.s3a.secret.key <secret-key>
    spark.hadoop.fs.s3a.path.style.access true
    spark.hadoop.fs.s3a.impl org.apache.hadoop.fs.s3a.S3AFileSystem
    spark.driver.extraJavaOptions -Dcom.amazonaws.sdk.disableCertChecking=true
    spark.executor.extraJavaOptions -Dcom.amazonaws.sdk.disableCertChecking=true
```

#### Separately for each Livy Session

You can configure S3 integration for each Livy Session separately on session creation by specifying S3-specific options in the `conf` parameter of the session creation request.

Example:
```bash
curl -ks \
    -u user:password \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{
        "kind": "spark"
        , "conf": {
            "spark.hadoop.fs.s3a.access.key": "<access-key>"
            , "spark.hadoop.fs.s3a.secret.key": "<secret-key>"
            , "spark.hadoop.fs.s3a.path.style.access": "true"
            , "spark.hadoop.fs.s3a.impl": "org.apache.hadoop.fs.s3a.S3AFileSystem"
            , "spark.driver.extraJavaOptions": "-Dcom.amazonaws.sdk.disableCertChecking=true"
            , "spark.executor.extraJavaOptions": "-Dcom.amazonaws.sdk.disableCertChecking=true"
        }
    }' \
    "https://${NODE_IP}:${NODE_PORT}/sessions" | jq
```


### DeltaLake integration

**Note:** DeltaLake integration is supported only for Spark 3+.

To integrate Livy Spark Sessions with DeltaLake, you need to put Delta Lake JAR in storage like DTap and configure Livy to load it.

Firstly, enable DTap DataTap for Livy Spark Sessions by adding the following options:
```json
{
    "conf": {
        "spark.hadoop.fs.dtap.impl": "com.bluedata.hadoop.bdfs.Bdfs"
        , "spark.hadoop.fs.AbstractFileSystem.dtap.impl": "com.bluedata.hadoop.bdfs.BdAbstractFS"
        , "spark.hadoop.fs.dtap.impl.disable.cache": "false"
        , "spark.kubernetes.driver.label.hpecp.hpe.com/dtap": "hadoop2"
        , "spark.kubernetes.executor.label.hpecp.hpe.com/dtap": "hadoop2"
        , "spark.driver.extraClassPath": "/opt/bdfs/bluedata-dtap.jar"
        , "spark.executor.extraClassPath": "/opt/bdfs/bluedata-dtap.jar"
    }
    , "jars": [
        "local:///opt/bdfs/bluedata-dtap.jar"
    ]
}
```

And add options that enable Delta Lake integration:
```json
{
    "conf": {
        ...
        , "spark.sql.extensions": "io.delta.sql.DeltaSparkSessionExtension"
        , "spark.sql.catalog.spark_catalog": "org.apache.spark.sql.delta.catalog.DeltaCatalog"
    }
    , "jars": [
        ...
        , "dtap:///mydatatap/delta_core_2.12-1.1.0.jar"
    ]
}
```

So the resulting example for session creation would be the following:
```bash
curl -ks \
    -u user:password \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{
        "kind": "spark"
        , "conf": {
            "spark.hadoop.fs.dtap.impl": "com.bluedata.hadoop.bdfs.Bdfs"
            , "spark.hadoop.fs.AbstractFileSystem.dtap.impl": "com.bluedata.hadoop.bdfs.BdAbstractFS"
            , "spark.hadoop.fs.dtap.impl.disable.cache": "false"
            , "spark.kubernetes.driver.label.hpecp.hpe.com/dtap": "hadoop2"
            , "spark.kubernetes.executor.label.hpecp.hpe.com/dtap": "hadoop2"
            , "spark.driver.extraClassPath": "/opt/bdfs/bluedata-dtap.jar"
            , "spark.executor.extraClassPath": "/opt/bdfs/bluedata-dtap.jar"
            , "spark.sql.extensions": "io.delta.sql.DeltaSparkSessionExtension"
            , "spark.sql.catalog.spark_catalog": "org.apache.spark.sql.delta.catalog.DeltaCatalog"
        }
        , "jars": [
            "local:///opt/bdfs/bluedata-dtap.jar"
            , "dtap:///mydatatap/delta_core_2.12-1.1.0.jar"
        ]
    }' \
    "https://${NODE_IP}:${NODE_PORT}/sessions" | jq
```

### High Availability

To start multiple Livy instances, you can change the value of `replicaCount` field in the `values.yaml`.

**Note:** Livy is a stateful application. Therefore, Livy clients must choose the Livy instance to use. Alternatively, you can configure the cluster's gateway to connect each client to their Livy instance automatically.

To achieve better high availability it is recommended to enable the session recovery feature in `values.yaml`.

### Configuring livy server with external OAuth proxy
Livy Server can be configured to work behind OAuth proxy server. The proxy is responsible for user authentication,
and sends only the username down to the livy server through a custom HTTP header.
Assuming that the custom header name is 'X-USERNAME', add the following change to values.yaml:
```yaml
extraConfigs:
  livy.conf: |
    livy.server.auth.multiauth.class = org.apache.hadoop.security.authentication.server.AuthenticationFilter
    livy.server.auth.multiauth.param.type = org.apache.spark.ui.filters.ProxyAuthenticationHandler
    livy.server.auth.multiauth.param.userheader = X-USERNAME
```

### Metrics

Compared to Apache Livy, this Livy build has the option to enable metrics during the creation of Livy Session.  
Metrics can be enabled by adding the `"enableMetrics": true` session option in the REST call, like this:
```bash
curl -ks \
    -u user:password \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{
        "kind": "spark"
        , "enableMetrics": true
    }' \
    "https://${NODE_IP}:${NODE_PORT}/sessions" | jq
```
It will create a Prometheus sink at the `/metrics` endpoint of Applications Spark UI and add corresponding Kubernetes annotations for Prometheus to discover the metrics of the session.

Alternatively, this can be enabled by default for all sessions by adding the following configuration in the `values.yaml`:
```yaml
extraConfigs:
  livy.conf: |
    spark.metrics.conf.driver.source.jvm.class org.apache.spark.metrics.source.JvmSource
    spark.metrics.conf.executor.source.jvm.class org.apache.spark.metrics.source.JvmSource
    spark.metrics.conf.*.sink.prometheusServlet.class org.apache.spark.metrics.sink.PrometheusServlet
    spark.metrics.conf.*.sink.prometheusServlet.path /metrics
    spark.kubernetes.driver.annotation.prometheus.io/scrape true
    spark.kubernetes.driver.annotation.prometheus.io/port 4040
    spark.kubernetes.driver.annotation.prometheus.io/path /metrics
```
