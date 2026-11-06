# syntax=docker/dockerfile:1.7
#
# PCOM-DI-Nifi-Ubuntu
# Pinned upstream image (apache/nifi:1.26.0) republished under the NNP Data Ingestion namespace.

FROM apache/nifi:1.26.0

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION="1.26.0-v1"

LABEL org.opencontainers.image.title="pcom-di-nifi-ubuntu" \
      org.opencontainers.image.description="NNP Data Ingestion component: nifi-ubuntu" \
      org.opencontainers.image.vendor="Nubo Native Platform" \
      org.opencontainers.image.source="https://github.com/NNP-Platform-Components-PCOM/PCOM-DI-Nifi-Ubuntu" \
      org.opencontainers.image.url="https://github.com/NNP-Platform-Components-PCOM/PCOM-DI-Nifi-Ubuntu" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.created="${BUILD_DATE}"

USER root

# Download JDBC drivers into a staging directory that is NOT overridden by the
# nifi_drivers named volume. The compose entrypoint copies them into the
# volume-mounted /opt/nifi/nifi-current/drivers/ on each container start.
RUN mkdir -p /opt/nifi-drivers-init && \
    curl -fsSL -o /opt/nifi-drivers-init/mysql-connector-j-9.4.0.jar \
      https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/9.4.0/mysql-connector-j-9.4.0.jar && \
    curl -fsSL -o /opt/nifi-drivers-init/postgresql-42.7.3.jar \
      https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.3/postgresql-42.7.3.jar && \
    chmod 644 /opt/nifi-drivers-init/*.jar && \
    chown -R nifi:nifi /opt/nifi-drivers-init

USER nifi
