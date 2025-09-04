ARG HIVE_IMAGE_TAG=4.0.0
# Stage 1: Builder stage with Gradle to download dependencies
FROM gradle:9.0.0-jdk24-ubi-minimal AS builder
WORKDIR /build
COPY build.gradle.kts .
RUN gradle copyLibs --no-daemon
RUN gradle dependencies --configuration runtimeClasspath > /build/libs/dependencies.txt

# Stage 2: Final Hive image with Hive + JDBC driver + entrypoint
FROM apache/hive:${HIVE_IMAGE_TAG}
COPY --from=builder /build/libs/* /opt/hive/lib/

USER root
RUN apt-get update && \
    apt-get install -y gettext-base && \
    rm -rf /var/lib/apt/lists/*

COPY config/hive-site.xml /opt/hive/conf/hive-site.xml.template
COPY scripts/entrypoint.sh /entrypoint.sh

RUN cp /opt/hive/conf/hive-log4j2.properties.template /opt/hive/conf/hive-log4j2.properties
RUN chmod +x /entrypoint.sh
RUN chown -R hive:hive /opt/hive/conf/

USER hive
ENTRYPOINT ["/entrypoint.sh"]
