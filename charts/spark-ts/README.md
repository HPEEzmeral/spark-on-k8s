# Helm Chart for Spark Thrift Server

Thrift JDBC/ODBC Server (aka Spark Thrift Server or STS) corresponds to the HiveServer2's built-in Hive. Spark Thrift server allows JDBC/ODBC clients to execute SQL queries over JDBC and ODBC protocols on Spark.

## Installing the Chart

### Install command
```sh
helm dependency update ./spark-ts-chart
helm install spark-ts ./spark-ts-chart -n sampletenant
```

This will create the helm chart in the `sampletenant` namespace.  This will create Thrift Server with v3.1.2  
Please note: This assumes you are installing in an 'internal' or 'external' Tenant Namespace. Installing spark-ts chart in a non -tenant namespace can cause error because of missing configmaps and secrets. 

To install thrift server V2.4.7 use the flags:  
`--set image.imageName=spark-ts-2.4.7 --set image.tag=202112061039R --set sparkVersion=spark-2.4.7`

#### Installing in a non DF Tenant
To install the helm chart in tenant type 'none' Namespace use the flag:  
`--set tenantIsUnsecure=true `

### Creating a service account
This helm chart does not create Service Account and RBAC. To use an existing Service Account either update values.yaml or use the following flag with install command: <br>
` --set serviceaccount.name=xyz  --set serviceaccount.create=false`

To create a new Service account use the flag:  
` --set serviceaccount.create=true`

To create a new RBAC for the service account use the flag:  
` --set rbac.create=true`

### Viewing the UI
After the chart is successfully installed, a message would be printed out to the console with details about how to access the UI.

## Uninstalling the Chart
`helm delete spark-ts -n sampletenant`
