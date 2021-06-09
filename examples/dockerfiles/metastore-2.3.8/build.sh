#!/usr/bin/env bash

docker build --no-cache --network=host -t apache-hive .

HIVE_VERSION="2.3.8"

tag=$(date +%Y%m%d%H%M)
docker tag apache-metastore gcr.io/mapr-252711/apache-hivemetastore-${HIVE_VERSION}:$tag
docker push gcr.io/mapr-252711/apache-hivemetastore-${HIVE_VERSION}:$tag
