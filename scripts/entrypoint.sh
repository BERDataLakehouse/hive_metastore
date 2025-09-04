#!/bin/bash
set -e

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

echo "Starting Hive Metastore with templatized /opt/hive/conf/hive-site.xml."
exec $HIVE_HOME/bin/hive --service metastore
