ARG HIVE_IMAGE_TAG

# Stage 1: Builder stage with Gradle to download dependencies
FROM gradle:8.7-jdk17 AS builder
WORKDIR /build
COPY build.gradle gradle.properties ./
RUN gradle build --no-daemon

# Stage 2: Final Hive image with Hive + JDBC driver + entrypoint
FROM apache/hive:${HIVE_IMAGE_TAG}

# Copy all downloaded JARs from builder stage
COPY --from=builder /build/libs/* /opt/hive/lib/

# Switch to root to install dependencies
USER root

RUN apt-get update && \
    apt-get install -y gettext-base && \
    rm -rf /var/lib/apt/lists/*

# Copy hive-site.xml template and entrypoint script
COPY config/hive-site.xml /opt/hive/conf/hive-site.xml.template
COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Make sure hive user can write to conf directory
RUN chown -R hive:hive /opt/hive/conf/

# Switch back to hive user
USER hive

# Use our custom entrypoint
ENTRYPOINT ["/entrypoint.sh"]
