# Helm Chart for Hivemetastore

### Installing the Chart

#### Install command
`helm install hivemeta ./hivemeta-chart -n sampletenant`

This will create the helm chart in the `sampletenant` namespace.  This will create Hive Metastore. </br>
Please note: This assumes you are installing in an 'internal' or 'external' Tenant Namespace. Installing hive-metastore chart in a non -tenant namespace can cause error because of missing configmaps and secrets.

### For Tenant type none
To install the helm chart in tenant type 'none' Namespace use the flag: <br>
`--set tenantIsUnsecure=true ` along with the install command

### For using MySQLDB as backend for hivemetastore
A secret containing credentials for mysql server needs to be present on the cluster
The secret name & namespace can be configured in values.yaml - mysqlNamespace,mysqlSecret
By default namespace is set to 'mysql-operator' & secret 'hivemeta-secret'
Format and command to create the hivemetastore secret is given at the bottom.
To use mysqlDB use flag along with the install command: <br>
`--set mysqlDB=true `

### Creating a service account
This helm chart does not create Service Account and RBAC. To use an existing Service Account either update values.yaml or use the following flag with install command: <br>
` --set serviceaccount.name=xyz  --set serviceaccount.create=false`

To create a new Service account use the flag: <br>
` --set serviceaccount.create=true`

To create a new RBAC for the service account use the flag: <br>
` --set rbac.create=true`

## Uninstalling the Chart
`helm delete hivemeta -n sampletenant`

### Format for the hivemetastore secret

#### NOTE : The xml file should be named - hivesite (no extensions)

Command to create secret from file hivesite is as follows

`kubectl create secret generic hivesite-secret --from-file=hivesite=../hivesite -n mysql-operator`

Filename : hivesite
Namespace for secret : msyql-operator

This secret should consist of an xml file data and the contents should be as follows:
```
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>javax.jdo.option.ConnectionUserName</name>
    <value>user</value>
    <description>USERNAME-FOR-MYSQL-SERVER-CONNECTION</description>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>password</value>
    <description>PASSWORD-FOR-MYSQL-SERVER-CONNECTION</description>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:mysql://"SVC_NAME.POD_NAMESPACE.svc.DNS_DOMAIN":MYSQL_PORT/metastore_db?createDatabaseIfNotExist=true</value>
    <description>MYSQL-SERVICE-ENDPOINT-FOR-SERVER-CONNECTION</description>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>com.mysql.cj.jdbc.Driver</value>
  </property>
</configuration>
```