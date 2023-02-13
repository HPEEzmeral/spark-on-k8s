ARG SPARK_IMAGE=apache/spark:v3.3.1
FROM ${SPARK_IMAGE}

COPY entrypoint.sh /opt

ENTRYPOINT ["/opt/entrypoint.sh"]
