FROM registry.access.redhat.com/ubi9/go-toolset:1.21.13-2.1729776560 AS builder

ARG uid=1001

WORKDIR /build
COPY --chown=${uid}:0 . .

RUN make clean vet build

FROM builder AS test

ARG uid=1001

RUN make clean vet

FROM registry.access.redhat.com/ubi9-minimal:9.6-1749489516 AS prod

ARG uid=1001

COPY --chown=${uid}:0 --from=builder /build/vault-exporter /
COPY --chown=${uid}:0 --from=builder /build/LICENSE /licenses/LICENSE
RUN \
  microdnf update -y && \
  microdnf install -y ca-certificates git && \
  microdnf clean all

USER ${uid}
ENTRYPOINT ["/vault-exporter"]
