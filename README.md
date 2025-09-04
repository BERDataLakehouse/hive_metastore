# BERDL Hive Metastore
* Keep `build.gradle.kts` in sync with the BERDL Jupyter Base Image gradle file

# Possible configurations to investigaete adding:
* export HADOOP_CLIENT_OPTS="${HADOOP_CLIENT_OPTS} -Xmx${HADOOP_CLIENT_HEAP:-1G}"
* --skiphadoopversion --skiphbasecp


### PostgreSQL Database Configuration

These variables configure the connection to the PostgreSQL database used by the Hive Metastore:

| Variable | Description | Example |
|----------|-------------|---------|
| `POSTGRES_HOST` | PostgreSQL server hostname or IP address | `localhost` |
| `POSTGRES_PORT` | PostgreSQL server port number | `5432` |
| `POSTGRES_DB` | Database name for the metastore | `metastore` |
| `POSTGRES_USER` | Database username for authentication | `hive` |
| `POSTGRES_PASSWORD` | Database password for authentication | `hivepassword` |

### Data Warehouse Configuration

| Variable | Description | Example |
|----------|-------------|---------|
| `DELTALAKE_WAREHOUSE_DIR` | Directory location for the Hive warehouse where table data is stored | `s3a://warehouse/` |

### S3/MinIO Storage Configuration

These variables configure S3-compatible storage (such as MinIO) for data storage:

| Variable | Description | Example |
|----------|-------------|---------|
| `S3_ENDPOINT` | S3A endpoint URL for MinIO or S3-compatible storage | `http://minio:9000` |
| `S3_ACCESS_KEY` | S3A access key for authentication | `minioadmin` |
| `S3_SECRET_KEY` | S3A secret key for authentication | `minioadmin` |

## Environment 


```bash
# PostgreSQL Configuration
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=metastore
POSTGRES_USER=hive
POSTGRES_PASSWORD=hivepassword

# Warehouse Configuration
DELTALAKE_WAREHOUSE_DIR=s3a://warehouse/

# S3/MinIO Configuration
S3_ENDPOINT=http://minio:9000
S3_ACCESS_KEY=minioadmin
S3_SECRET_KEY=minioadmin
```