plugins {
    java
}

repositories {
    mavenCentral()
}

// IMPORTANT: Version compatibility chain - all versions must be aligned to avoid compatibility issues
// Hive 4.0.0 → Hadoop 3.3.6
val hadoopAwsVersion = "3.3.6"    // Must match Hive container's 4.0.0's bundled Hadoop
val postgresVersion = "42.7.7"

dependencies {
    runtimeOnly("org.postgresql:postgresql:$postgresVersion")
    runtimeOnly("org.apache.hadoop:hadoop-aws:$hadoopAwsVersion")
}

tasks.register<Copy>("copyLibs") {
    from(configurations.runtimeClasspath)
    into("libs")
}