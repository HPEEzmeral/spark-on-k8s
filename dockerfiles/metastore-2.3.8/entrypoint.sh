#!/usr/bin/env bash

/opt/hive/bin/schematool -initSchema -dbType mysql
/opt/hive/bin/hive --service metastore