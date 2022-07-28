#!/usr/bin/env bash


KUBECTL_APPLY="kubectl apply -f"
KUBECTL_CREATE_SECRET="kubectl create secret generic imagepull-secret --type=kubernetes.io/dockerconfigjson --from-file=.dockerconfigjson=imagepull_secret_file"
IMAGE_NAME=$1
IMAGE_JOB="download-image-job.yaml"

download_image() {
  export DOWNLOADED_IMAGE=${IMAGE_NAME}
  envsubst < $IMAGE_JOB | ${KUBECTL_APPLY} -
  if [ $? -eq 0 ]; then
    echo "Successfully created job for downloading image"
  else
    echo "Error while creating job for downloading image"
  fi
}

create_secret() {
  ${KUBECTL_CREATE_SECRET}
  if [ $? -eq 0 ]; then
    echo "Successfully created imagepull secret"
    download_image
  else
    echo "Error while creating imagepull secret"
  fi
}

create_secret

