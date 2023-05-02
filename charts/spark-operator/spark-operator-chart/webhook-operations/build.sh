#!/usr/bin/env bash

docker build --no-cache --network=host -t autoticket-generator-hook .

VERSION="1.0.0"

tag=$(date +%Y%m%d%H%M)
docker tag autoticket-generator-hook gcr.io/mapr-252711/autoticket-generator-hook-${VERSION}:$tag
docker push gcr.io/mapr-252711/autoticket-generator-hook-${VERSION}:$tag
