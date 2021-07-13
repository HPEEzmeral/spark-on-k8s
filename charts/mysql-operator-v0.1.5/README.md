## Full MySQL Operator Documentation
https://github.com/presslabs/mysql-operator
## Helm Charts configuration documentation
https://github.com/presslabs/mysql-operator/tree/master/charts/mysql-operator

##Steps
## 1. Install operator
## 2. Create mysql-cluster

## Examples
####Create mysql-operator
Common way to install mysql-operator:
```shell script
helm install -f mysql-operator-chart/values.yaml mysql-operator mysql-operator-chart/
```
Command above creates a namespace 'spark-operator' and all related components inside it, including an image pull secret.

####Delete mysql-operator
Deployed mysql operator can be removed using command below.
```shell script
helm delete mysql-operator
```

#### This chart adds an init container to the statefulset template to change the permissions of pv created

## MySQL Cluster creation
### 
```shell script
kubectl apply -f mysql-cluster.yaml
```
