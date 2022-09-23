# Running spark-rapids-integration-tests

1. Clone project
```shell
Git clone https://github.com/NVIDIA/spark-rapids.git \
```
2.Copy integration_tests to maprfs \

```shell

kubectl cp integration_tests to maprfs
```

3.Start integration test execution \

```shell
kubectl apply -f it-executor.yaml
```
4. To run specific test modify spark-rapids-it-runner.yaml

```yaml
#    - -k explain_test # specific test for execution
```