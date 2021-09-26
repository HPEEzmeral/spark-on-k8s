ARG SPARK_IMAGE=gcr.io/spark-operator/spark:v3.1.1
FROM ${SPARK_IMAGE}

COPY entrypoint.sh /opt/

USER root

RUN chmod +x /opt/entrypoint.sh
RUN chmod 777 /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]