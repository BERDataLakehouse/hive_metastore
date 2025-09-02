FROM apache/hive:standalone-metastore-4.1.0
COPY postgresql-42.7.7.jar /opt/hive/lib/
