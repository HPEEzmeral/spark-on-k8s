# Helm Chart for Spark Operator V3.1.2

### Installing the Chart

#### Install command
`helm install spark-operator ./spark-operator-chart -n spark-operator-ns`

This will create spark operator components in already created `spark-operator-ns` . If the `-n` option is not provided, helm chart will create a new namespace using the 
release namespace.

### Install without spark SA and RBAC 

`helm install spark-operator ./spark-operator-chart -n spark-operator-ns --set serviceAccounts.spark.create=false,rbac.create=false`

## Uninstalling the Chart

`helm delete spark-operator -n spark-operator-ns`
