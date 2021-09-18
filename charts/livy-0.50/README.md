# Helm Chart for Livy-0.5.0

[Livy](https://livy.incubator.apache.org/) provides a REST API for Apache Spark.

## Installing the Chart

Note that this chart requires ECP tenant operator to be installed and Tenant CR applied in the tenant namespace.

### Install command
`helm install livy ./livy-chart `

This will create the helm chart in the `default` namespace. To create the chart in a different existing namespace use the flag
` -n sampletenant `.
Please note that if you are using PVC, the pvc should exist in the same namespace.

To set the tenant namespace use the flag `--set tenantNameSpace=sampletenant` during installation

Integrations for Spatrk History server and metastore can be customized in the Values.yaml file.

## Uninstalling the Chart

`helm delete livy -n sampletenant`

Please note that this won't delete the PVC in case you are using a PVC. PVC will have to be manually deleted.
