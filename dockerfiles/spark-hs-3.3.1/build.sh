#!/usr/bin/env bash

chmod +x entrypoint.sh
docker build --no-cache --network=host -t apache-spark-hs .

VERSION="3.3.1"

tag=$(date +%Y%m%d%H%M)-AJ
docker tag apache-spark-hs gcr.io/mapr-252711/apache-spark-hs-${VERSION}:$tag
docker push gcr.io/mapr-252711/apache-spark-hs-${VERSION}:$tag