# Helm Chart for Livy-0.7.0

[Livy](https://livy.incubator.apache.org/) provides a REST API for Spark.

## Installing the Chart

Note that this chart requires ECP tenant operator to be installed and Tenant CR applied in the tenant namespace.

### Install command
`helm install livy ./livy-chart -n sampletenant`

This will create the helm chart in the `sampletenant` namespace.  
Please note:
* This assumes you are installing in an 'internal' or 'external' Tenant Namespace. Installing livy chart in a non tenant namespace can cause error because of missing configmaps and secrets.
* If you are using PVC, the pvc should exist in the same namespace.
* Integrations for Spark History server and metastore can be customized in the values.yaml file.

#### Installing in a non DF Tenant
To install the helm chart in tenant type 'none' Namespace use the flag:  
`--set tenantIsUnsecure=true `

## Uninstalling the Chart
`helm delete livy -n sampletenant`

Please note that this won't delete the PVC in case you are using a PVC. PVC will have to be manually deleted.
