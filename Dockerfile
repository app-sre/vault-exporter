FROM registry.access.redhat.com/ubi8-minimal
COPY vault-exporter /usr/bin/vault-exporter
ENTRYPOINT ["/usr/bin/vault-exporter"]
