# Full Apache Spark On K8S Documentation 
https://github.com/GoogleCloudPlatform/spark-on-k8s-operator
# Helm Charts configuration documentation
https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/tree/master/charts/spark-operator-chart

Easiest way to install spark-operator is to:
helm install -f spark-operator-chart/values.yaml spark-operator ./spark-operator-chart

In case you want to create spark-operator in namespace which is not created yet

example:
helm install -f spark-operator-chart/values.yaml spark-operator ./spark-operator-chart --namespace spark-operator --create-namespace

In case spark-operator image is downloaded from custom docker repository custom imagePullSecrets should be added

example:
helm install -f spark-operator-chart/values.yaml spark-operator ./spark-operator-chart --set imagePullSecrets[0].name="imagepull"

<b>Delete spark-operator:</b>

helm delete spark-operator

# Examples: 
<br><b>Create operator and submit spark-pi job in default namespace</b>
```shell
$ kubectl create secret generic imagepull --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson
$ helm install spark-operator ./spark-operator-chart --set imagePullSecrets[0].name="imagepull"
$ kubectl apply -f spark-pi.yaml
```
<br><b>Create operator and submit spark-pi job in different namespaces</b>
```shell
$ kubectl create namespace spark-operator
$ kubectl create secret generic imagepull --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson
$ kubectl create secret generic imagepull --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson -n spark-operator
$ helm install spark-operator ./spark-operator-chart --set imagePullSecrets[0].name="imagepull" --namespace spark-operator --set sparkJobNamespace=default
$ kubectl apply -f spark-pi.yaml
```