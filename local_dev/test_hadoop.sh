#!/usr/bin/env bash
# This script allows you to test hadoop client within the hive container

export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/hive/lib/*

hadoop fs -D fs.s3a.endpoint=$S3_ENDPOINT \
         -D fs.s3a.access.key=$S3_ACCESS_KEY \
         -D fs.s3a.secret.key=$S3_SECRET_KEY \
         -D fs.s3a.path.style.access=true \
         -D fs.s3a.connection.ssl.enabled=true \
         -stat s3a://$DELTALAKE_WAREHOUSE_DIR/<filename>