# Script to fetch all image names and tags and download all images from GCR repository on local setup

### Prerequisites:
1. Install python
2. Install yaml package for python
```
pip3 install yaml
```
3. Install minikube on your local setup with docker runtime and appropriate configs
```
minikube config set cpus 6
minikube config set memory 64g
minikube config set disk-size 64g
```
4. Start the minikube single node setup
```
minikube start --driver=hyperkit --container-runtime=docker
```
5. Set up docker env variables
```
minikube docker-env
eval $(minikube -p minikube docker-env)
```
NOTE: kubectl now has been configured to point to the minikube setup automatically.
NOTE: docker now has been configured to be used in current session window.

#### Store image names and tags in a file
Run the following command from fetch_tag directory to execute the fetch tag script
```
chmod +x fetch_tag.sh
./fetch_tag.sh
```

#### Download all images from the file and save them to a tar archive
Run the following command from download_all_images directory to execute the download-images script
```
chmod +x download-images.sh
./download-images.sh --image-list imagelist.txt
```

###  Unload the images.tar.gz to docker as images
Use the following command to get the docker images loaded from .tar.gz
```
docker load < images.tar.gz
```
