#!/bin/bash
set -e

echo "Starting Hive Metastore with environment variable substitution..."

# Process hive-site.xml with environment variable substitution
envsubst < /opt/hive/conf/hive-site.xml.template > /opt/hive/conf/hive-site.xml

echo "Generated hive-site.xml with current environment variables"

# Initialize schema if needed
echo "Checking Hive metastore schema..."
if $HIVE_HOME/bin/schematool -dbType postgres -info >/dev/null 2>&1; then
    echo "Metastore schema already initialized."
else
    echo "Metastore schema not found; initializing..."
    $HIVE_HOME/bin/schematool -dbType postgres -initSchema
fi

# Start Hive Metastore service
echo "Starting Hive Metastore..."
exec $HIVE_HOME/bin/hive --service metastore
