# Script to download image from GCR repository on local setup

### Prerequisites:
1. Install minikube on your local setup
2. Start the minikube single node setup
Note: kubectl now has been configured to point to the minikube setup automatically.

#### Run the following command to execute the image download script
```
./download-image.sh <IMAGE_NAME>
```

### Parameter passed to download-image script
The parameter is the full name of the image you wish to download. For e.g.
```
gcr.io/mapr-252711/spark-2.4.7:202205231142R
```
The above image name contains the GCR repository's entire path.

