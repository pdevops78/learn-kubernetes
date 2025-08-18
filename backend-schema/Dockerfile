FROM                         docker.io/redhat/ubi9
RUN                          dnf install mysql git -y
RUN                          mkdir /app
COPY                         run.sh /app/run.sh
ENTRYPOINT                   ["bash","/app/run.sh"]