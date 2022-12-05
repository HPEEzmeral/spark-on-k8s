FROM rockylinux/rockylinux

RUN mkdir /opt/tenantvalidator

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl
RUN  cd /tmp/ && \
     yum update -y && \
     yum install openssl openssl-devel -y

COPY tenantvalidator-csr.yaml /opt/tenantvalidator/tenantvalidator-csr.yaml
COPY tenantvalidator-gencert.sh /opt/tenantvalidator/tenantvalidator-gencert.sh
COPY tenantvalidator-mwhconfig.yaml /opt/tenantvalidator/tenantvalidator-mwhconfig.yaml
COPY tenantvalidator-vwhconfig.yaml /opt/tenantvalidator/tenantvalidator-vwhconfig.yaml
COPY tenantvalidator-uninstall.sh /opt/tenantvalidator/tenantvalidator-uninstall.sh

RUN chmod +x /opt/tenantvalidator/tenantvalidator-gencert.sh
RUN chmod +x /opt/tenantvalidator/tenantvalidator-uninstall.sh

WORKDIR /opt/tenantvalidator

CMD ["sh", "/opt/tenantvalidator/tenantvalidator-gencert.sh"]