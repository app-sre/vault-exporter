FROM centos:7

RUN curl -sOL https://github.com/grapeshot/vault_exporter/releases/download/v0.1.2/vault_exporter_0.1.2_linux_amd64.tar.gz \
    && tar -zxvf vault_exporter_0.1.2_linux_amd64.tar.gz \
    && mv vault_exporter /usr/bin

ENTRYPOINT ["/usr/bin/vault_exporter"]