# Helm Chart for Spark Client V3.1.1

### Installing the Chart

#### Install command
`helm install spark-client ./spark-client-chart -n spark-ns`

This will create spark client deployment in already created `spark-ns`. to create a new namespace during installation use the flag `--create-namespace`  with the installation command

## Uninstalling the Chart

`helm delete spark-client -n spark-ns`
