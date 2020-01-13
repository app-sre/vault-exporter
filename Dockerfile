FROM centos:7
COPY vault-exporter /usr/bin/vault-exporter
ENTRYPOINT ["/usr/bin/vault-exporter"]
