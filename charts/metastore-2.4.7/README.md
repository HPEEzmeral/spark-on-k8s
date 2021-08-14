# Helm Chart for Hivemetastore

### Installing the Chart

#### Install command
`helm install hivemeta ./hivemeta-chart -n sampletenant`

This will create the helm chart in the `sampletenant` namespace.</br>
Please note: you will have to create this namespace by applying tenant-cr and having the tenant operator installed. Installing metastore-2.4.7 chart in a non -tenant namespace can cause error because of missing configmaps and secrets.

## Uninstalling the Chart

`helm delete hivemeta -n sampletenant`