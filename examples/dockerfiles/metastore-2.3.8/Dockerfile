FROM amd64/openjdk:8-jre

WORKDIR /opt

ENV HADOOP_VERSION=2.10.1
ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/hive
ENV HADOOP_HOME=/opt/hadoop
ENV HIVE_VERSION=2.3.8

RUN mkdir ${HIVE_HOME} ${HADOOP_HOME} && \
    curl -fsSL https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz | tar zx --strip-components=1 -C ${HIVE_HOME} && \
    curl -fsSL https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zx --strip-components=1 -C ${HADOOP_HOME}

COPY hive-site.xml ${HIVE_HOME}/conf

RUN ${HIVE_HOME}/bin/schematool -initSchema -dbType derby

#Setup Hive Metastore service ports
EXPOSE 9083
WORKDIR $HIVE_HOME

ENTRYPOINT ["bin/hive"]
CMD ["--service", "metastore"]


