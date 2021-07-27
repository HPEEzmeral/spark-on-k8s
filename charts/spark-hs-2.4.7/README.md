## Configuring event log storage type

### Use maprfs as event log storage
Spark HS supports two kinds of event storage type: maprfs-based and PVC-based. Maprfs-based kind is default for tenants. 
In this case spark HS reads event log directly from maprfs "/apps/spark/[tenant-namespace]" directory.
### Use PVC as event log storage
If configured with "pvc" kind, spark HS will assume that PVC with given name exists in the namespace. This PVC will be
mounted to spark-hs service pod and spark will read event logs from it. Spark applications will be configured automatically
to use the same PVC as event log storage.

## Examples

Install spark history server deployment named 'spark-test-hs' in 'test' tenant:
```shell script
helm install -f spark-hs-chart/values.yaml spark-test-hs ./spark-hs-chart \
--namespace test \
--set tenantNameSpace=test \
--set tenantServiceAccount.name=hpe-test
```

Install spark history server deployment named 'spark-test-hs' in 'test' tenant using maprfs as spark apps log storage:
```shell script
helm install -f spark-hs-chart/values.yaml spark-test-hs ./spark-hs-chart \
--namespace test \
--set tenantNameSpace=test \
--set tenantServiceAccount.name=hpe-test \
--set eventlogstorage.kind=maprfs
```

Install spark history server deployment named 'spark-test-hs' in 'test' tenant using PVC 'spark-hs-pvc' as spark apps log storage:
```shell script
helm install -f spark-hs-chart/values.yaml spark-test-hs ./spark-hs-chart \
--namespace test \
--set tenantNameSpace=test \
--set tenantServiceAccount.name=hpe-test \
--set eventlogstorage.kind=pvc \
--set eventlogstorage.pvcname=spark-hs-pvc
```

Uninstall spark history server deployment named "spark-test-hs" from 'test' tenant
```shell script
helm uninstall spark-test-hs --namespace test
```
