Helm Charts for Apache Metastore 2.3.8

To install use :

helm install -f metastore-chart/values.yaml metastore ./metastore-chart --create-namespace --namespace <NAMESPACE>

To delete use :

helm delete metastore -n <NAMESPACE>



