Helm Charts for Standalone Apache Metastore 3.0

To install use :

helm install -f metastore-chart/values.yaml metastore ./metastore-chart --create-namespace --namespace apache-metastore

To delete use :

helm delete metastore -n apache-metastore