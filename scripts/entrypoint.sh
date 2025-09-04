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

hadoop_version=$(hadoop version | head -n 1 | awk '{print $2}')
echo "Starting Hive Metastore with templatized /opt/hive/conf/hive-site.xml with hadoop:$hadoop_version"
exec $HIVE_HOME/bin/hive --verbose --service metastore
