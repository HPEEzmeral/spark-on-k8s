# Helm Chart for Spark Thrift Server

Thrift JDBC/ODBC Server (aka Spark Thrift Server or STS) corresponds to the HiveServer2's built-in Hive. Spark Thrift server allows JDBC/ODBC clients to execute SQL queries over JDBC and ODBC protocols on Apache Spark.

### Installing the Chart

#### Install command
`helm install spark-ts ./spark-ts-chart -n sampletenant`

This will create the helm chart in the `sampletenant` namespace.</br>
Please note: you will have to create this namespace by applying tenant-cr and having the tenant operator installed. Installing spark-ts-2.4.7 chart in a non -tenant namespace can cause error because of missing configmaps and secrets. 

#### Creating a service account

helm chart will create a new Service account with necessary RBAC. To use an existing Service Account either update values.yaml or use the following flag with install command:

` --set serviceaccount.name=xyz  --set serviceaccount.create=false`

#### Viewing the UI
After the chart is successfully installed, a message would be printed out to the console with details about how to access the UI.

## Uninstalling the Chart

`helm delete spark-ts -n sampletenant`
