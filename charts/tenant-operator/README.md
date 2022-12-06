# Helm Chart for Tenant Operator and Validator

### Installing the Chart

#### Install command
```sh
helm install tenant-operator tenant-operator/
```

#### NOTE: This will create the helm chart in the `default` namespace.
The chart installation will create Tenant operator and tenant validator webhook.
All the resources defined in the chart are created in `hpe-system` namespace.


## Uninstalling the Chart
`helm delete tenant-operator`
