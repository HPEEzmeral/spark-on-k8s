FROM gcr.io/mapr-252711/spark-gpu-3.2.0:${latest tag}
RUN pip3 install --upgrade pip
RUN sudo ln /usr/local/bin/pip /usr/bin/pip
RUN sudo -u mapr pip install numpy pandas pyarrow pytest sre_yield
RUN yum install git -y
USER mapr
RUN git clone -b branch-${branch version} --single-branch https://github.com/NVIDIA/spark-rapids.git /tmp/spark-rapids