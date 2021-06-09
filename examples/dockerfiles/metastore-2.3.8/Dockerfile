FROM amd64/openjdk:8

WORKDIR /opt

ENV HADOOP_VERSION=2.10.1
ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/hive
ENV HIVE_VERSION=2.3.8

RUN mkdir ${HIVE_HOME}

RUN curl -fSL https://downloads.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz | tar zxf - && \
    cp -r apache-hive-${HIVE_VERSION}-bin/* ${HIVE_HOME}/ && \
    curl -fSL https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf -

COPY hive-site.xml ${HIVE_HOME}/conf

RUN ${HIVE_HOME}/bin/schematool -initSchema -dbType derby

#Setup Hive Metastore service ports
EXPOSE 9083
WORKDIR $HIVE_HOME

ENTRYPOINT ["bin/hive"]
CMD ["--service", "metastore"]


