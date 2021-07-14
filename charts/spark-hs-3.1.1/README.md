# Helm Chart for Spark History Server

[Spark History Server](https://spark.apache.org/docs/latest/monitoring.html#viewing-after-the-fact) provides a web UI for completed and running Spark applications. The supported storage backends are HDFS and PersistentVolumeClaim (PVC)

### Installing the Chart

Note that only when `pvc.enablePVC` is set to `true`, the following settings take effect:

* pvc.existingClaimName
* pvc.eventsDir

#### Install command
`helm install spark-hs ./spark-hs-chart `

This will create the helm chart in the `default` namespace. To create the chart in a new namespace you can use these flags:
`--create-namespace --namespace spark-ns`
Please note that if you are using PVC, the pvc should exist in the same namespace.

#### Viewing the UI
After the chart is successfully installed, a message would be printed out to the console with details about how to access the UI.


## Uninstalling the Chart

`helm delete spark-hs -n spark-ns`

Please note that this won't delete the PVC in case you are using a PVC. PVC will have to be manually deleted.