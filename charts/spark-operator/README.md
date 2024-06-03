The helm chart is preconfigured to deploy spark operator in a tenant namespace.
Some values (e.g. imagepullsecret, service accounts) are preset. By default, spark job RBACs
are not created by the chart.

To install spark operator in 'compute' tenant, execute the following script:
```shell
helm install -f spark-operator-chart/values.yaml spark-operator-compute ./spark-operator-chart/ \
--namespace compute \
--set sparkJobNamespace=compute \
--set webhook.namespaceSelector=hpe.com/tenant=compute \
--set fullnameOverride=spark-operator-compute
```

Autoticket generator webhook is not installed by default in the given namespace.

To enable the installation of autoticket generator use the flag:

`--set autotix.enable=true`

This will create the helm chart in the `compute` namespace.  This will install Spark Operator version 3.1.2 as default </br>

Uninstalling chart from 'compute' namespace:
```shell
helm uninstall spark-operator-compute -n compute
```
