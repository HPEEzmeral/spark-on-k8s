#!/usr/bin/env bash

# echo commands to the terminal output
set -ex

enablePVC=

eventsDir=

function usage {
  cat<< EOF
  Usage: entrypoint.sh  [OPTIONS]

  Options:

  --pvc                                                 Enable PVC
  --events-dir events-dir                               Set events dir
  -h | --help                                           Prints this message.
EOF
}

function parse_args {
  while [[ $# -gt 0 ]]
  do
    case "$1" in
      --pvc)
        enablePVC=true
        shift
        continue
      ;;
      --events-dir)
        if [[ -n "$2" ]]; then
          eventsDir=$2
          shift 2
          continue
        else
          printf '"--events-dir" requires a non-empty option argument.\n'
          usage
          exit 1
        fi
      ;;
      -h|--help)
        usage
        exit 0
      ;;
      --)
        shift
        break
      ;;
      '')
        break
      ;;
      *)
        printf "Unrecognized option: $1\n"
        exit 1
      ;;
    esac
    shift
  done
}

parse_args "$@"

# Check whether there is a passwd entry for the container UID
uid=$(id -u)
gid=$(id -g)
# turn off -e for getent because it will return error code in anonymous uid case
set +e
uid_entry=$(getent passwd ${uid})
set -e

# If there is no passwd entry for the container UID, attempt to create one
if [[ -z "${uid_entry}" ]] ; then
    if [[ -w /etc/passwd ]] ; then
        echo "$uid:x:$uid:$gid:anonymous uid:${SPARK_HOME}:/bin/false" >> /etc/passwd
    else
        echo "Container entrypoint.sh failed to add passwd entry for anonymous UID"
    fi
fi

if [[ "$enablePVC" == "true" ]]; then
    export SPARK_HISTORY_OPTS="$SPARK_HISTORY_OPTS \
    -Dspark.history.fs.logDirectory=file:/mnt/$eventsDir";
else
    export SPARK_HISTORY_OPTS="$SPARK_HISTORY_OPTS \
    -Dspark.history.fs.logDirectory=s3a/test/tmp";
fi;

exec /bin/bash -s -- /opt/spark/bin/spark-class org.apache.spark.deploy.history.HistoryServer