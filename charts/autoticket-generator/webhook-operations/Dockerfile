FROM rockylinux/rockylinux

RUN mkdir /opt/autoticket-generator

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl
RUN  cd /tmp/ && \
     yum update -y && \
     yum install openssl openssl-devel -y

COPY autoticket-generator-csr.yaml /opt/autoticket-generator/autoticket-generator-csr.yaml
COPY autoticket-generator-gencert.sh /opt/autoticket-generator/autoticket-generator-gencert.sh
COPY autoticket-generator-mwhconfig.yaml /opt/autoticket-generator/autoticket-generator-mwhconfig.yaml
COPY autoticket-generator-vwhconfig.yaml /opt/autoticket-generator/autoticket-generator-vwhconfig.yaml
COPY autoticket-generator-uninstall.sh /opt/autoticket-generator/autoticket-generator-uninstall.sh

RUN chmod +x /opt/autoticket-generator/autoticket-generator-gencert.sh
RUN chmod +x /opt/autoticket-generator/autoticket-generator-uninstall.sh

WORKDIR /opt/autoticket-generator

CMD ["sh", "/opt/autoticket-generator/autoticket-generator-gencert.sh"]