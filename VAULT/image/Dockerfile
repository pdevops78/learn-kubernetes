FROM               redhat/ubi9
RUN                dnf install unzip -y
RUN                curl -L -o /tmp/vault.zip https://releases.hashicorp.com/vault/1.20.2/vault_1.20.2_linux_amd64.zip
RUN                unzip /tmp/vault.zip
RUN                mv vault /bin ; rm -rf /tmp/vault.zip