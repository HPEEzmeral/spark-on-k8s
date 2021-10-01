# Helm Chart for Livy-0.5.0

[Livy](https://livy.incubator.apache.org/) provides a REST API for Spark.

## Installing the Chart

Note that this chart requires ECP tenant operator to be installed and Tenant CR applied in the tenant namespace.

### Install command
`helm install livy ./livy-chart -n sampletenant`

This will create the helm chart in the `sampletenant` namespace.  </br>
Please note: 
<li>This assumes you are installing in an 'internal' or 'external' Tenant Namespace. Installing spark-ts chart in a non -tenant namespace can cause error because of missing configmaps and secrets. </li>
<li>If you are using PVC, the pvc should exist in the same namespace.</li>

Integrations for Spark History server and metastore can be customized in the Values.yaml file.

#### Installing in a non DF Tenant
To install the helm chart in tenant type 'none' Namespace use the flag: <br>
`--set tenantIsUnsecure=true `

## Uninstalling the Chart

`helm delete livy -n sampletenant`

Please note that this won't delete the PVC in case you are using a PVC. PVC will have to be manually deleted.
