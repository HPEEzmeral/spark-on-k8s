##MySQL Operator Documentation
https://www.percona.com/doc/kubernetes-operator-for-pxc/index.html
## Helm Charts configuration documentation
https://github.com/percona/percona-helm-charts/tree/main/charts

##NOTE : This is just a reference for testing MySQL support
1. Backup is disabled by default for these helm charts.
2. External mysql service is created in these helm charts, we can connect to this nodeport service
from another k8s cluster. To access it from another cluster we will have to get the nodeport at which
it is exposed and use the IP address of any node on this k8s cluster along with this port as svc endpoint.
Eg: service end point will be <NODE-IP>:<NODEPORT-PORT>

##Steps
## 1. Install operator helm chart
## 2. Install cluster helm chart

## Examples
####Install mysql-operator
Common way to install mysql-operator:
```shell script
helm install -f pxc-operator/values.yaml my-op pxc-operator/ -n mysql-operator --create-namespace
```
Command above creates a namespace 'mysql-operator' and installs the pxc-operator(mysql operator)

####Install mysql cluster after mysql operator is installed

## MySQL Cluster creation
Common way to install mysql-cluster:
```shell script
helm install -f pxc-db/values.yaml my-db pxc-db/ -n mysql-operator
```

## Set pxc_strict_mode to permissive for bypassing validations
Login to the mysql server by creating a mysql client pod as follows
```shell script
kubectl run -i --tty --rm percona-client --image=percona --restart=Never -- mysql -h ${HOST} -u${USER} -p${PASSWORD}
```
After the mysql prompt appears run
```shell script
SET GLOBAL pxc_strict_mode=PERMISSIVE;
```
Exit the pod

Command above installs the mysql cluster

####Delete mysql cluster
Deployed mysql cluster can be removed using command below
```shell script
helm delete my-db -n mysql-operator
```

####Delete mysql-operator after the cluster is completely removed
Deployed mysql operator can be removed using command below.
```shell script
helm delete my-op -n mysql-operator
```
