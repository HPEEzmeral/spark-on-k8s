#!/usr/bin/env bash

docker build --no-cache --network=host -t tenantvalidator-hook .

VERSION="1.0.0"

tag=$(date +%Y%m%d%H%M)
docker tag tenantvalidator-hook gcr.io/mapr-252711/tenantvalidator-hook-${VERSION}:$tag
docker push gcr.io/mapr-252711/tenantvalidator-hook-${VERSION}:$tag