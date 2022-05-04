# Helm Chart for Spark Client V3.2.0

### Installing the Chart

#### Install command
`helm install spark-client ./spark-client-chart -n sampletenant`

This will create spark client deployment in already created `sampletenant`. to create a new namespace during installation use the flag `--create-namespace`  with the installation command

To install spark client V2.4.7 use the flags:
`--set image.imageName=spark-client-2.4.7 --set image.tag=202110041707C`

#### Installing in a non DF Tenant
To install the helm chart in tenant type 'none' Namespace use the same command as for DF Tenant

## Uninstalling the Chart

`helm delete spark-client -n sampletenant`
