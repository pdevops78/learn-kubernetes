FROM                         docker.io/redhat/ubi9
RUN                          dnf install mysql -y
RUN                          mkdir /app
COPY                         schema/ /app/
COPY                         run.sh /
ENTRYPOINT                   ["bash","/run.sh"]