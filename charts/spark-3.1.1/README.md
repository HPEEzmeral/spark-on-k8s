## Full Apache Spark Operator Documentation 
https://github.com/GoogleCloudPlatform/spark-on-k8s-operator
## Helm Charts configuration documentation
https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/tree/master/charts/spark-operator-chart

## Examples 
####Create spark-operator
Common way to install spark-operator with admission webhook:
```shell script
helm install -f spark-operator-chart/values.yaml spark-operator ./spark-operator-chart --namespace spark-operator --create-namespace --set webhook.enable=true
```
Command above creates a namespace 'spark-operator' and all related components inside it, including an image pull secret.

In case you need to use another secret (e.g., to pull images from private docker registry), you should create namespace and secret manually.
In this case default secret will not be created.
After that, you can create spark-operator using the following command, putting there namespace and secret name:
```shell script
helm install -f spark-operator-chart/values.yaml spark-operator ./spark-operator-chart -n [your-namespace] --set imagePullSecrets[0].name=[imagepull-secret-name]
```

####Delete spark-operator
Deployed spark operator can be removed using command below. Put attention that spark application CRDs are not removed automatically.
```shell script
helm delete spark-operator -n [operator-namespace]
```
