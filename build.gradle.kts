plugins {
    `java`
}


// IMPORTANT: Version compatibility chain - all versions must be aligned to avoid compatibility issues
// Hive 4.0.0 → Hadoop 3.3.6
def hadoopAwsVersion = "3.3.6"    // Must match Hive container's 4.0.0's bundled Hadoop
def postgresVersion = "42.7.7"

dependencies {
    implementation "org.postgresql:postgresql:$postgresVersion"
    implementation "org.apache.hadoop:hadoop-aws:$hadoopAwsVersion"
}

tasks.create<Copy>("copyLibs") {
    from(configurations.runtimeClasspath)
    into("libs")
}