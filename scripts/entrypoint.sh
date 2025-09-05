#!/bin/bash
set -e
set -x

envsubst < /opt/hive/conf/hive-site.xml.template > /opt/hive/conf/hive-site.xml
echo "Generated hive-site.xml with current environment variables"

echo "Checking Hive metastore schema..."
if $HIVE_HOME/bin/schematool -dbType postgres -info >/dev/null 2>&1; then
    echo "Metastore schema already initialized."
else
    echo "Metastore schema not found; initializing..."
    $HIVE_HOME/bin/schematool -dbType postgres -initSchema
fi


if [[ "$S3_ENDPOINT" != http* ]]; then
    echo "Error: S3_ENDPOINT must start with 'http' or 'https'. Current value: $S3_ENDPOINT"
    exit 1
fi

# Test to ensure we can access S3 with the provided credentials

export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/opt/hive/lib/*

# remove s3a:// from warehouse dir if it exists
export BUCKET_TEST_DIR=${DELTALAKE_WAREHOUSE_DIR#s3a://}

# Capture both stdout and stderr for error reporting
error_output=$(hadoop fs -D fs.s3a.endpoint=$S3_ENDPOINT \
                       -D fs.s3a.access.key=$S3_ACCESS_KEY \
                       -D fs.s3a.secret.key=$S3_SECRET_KEY \
                       -D fs.s3a.path.style.access=true \
                       -D fs.s3a.connection.ssl.enabled=true \
                       -stat s3a://$BUCKET_TEST_DIR 2>&1)
result_code=$?

if [ $result_code -eq 0 ]; then
    echo "S3 connection successful"
else
    echo "S3 connection failed with code: $result_code"
    echo "Error details: $error_output"
    exit $result_code
fi

hadoop_version=$(hadoop version | head -n 1 | awk '{print $2}')
echo "Starting Hive Metastore with templatized /opt/hive/conf/hive-site.xml with hadoop:$hadoop_version"
exec $HIVE_HOME/bin/hive --verbose --service metastore
