# Dockerfile
FROM openjdk:8-jre-alpine

# Set environment variables for Spark
# As of the day of this commit, supported spark version 3.4.4 and 3.5.3 
# Check https://downloads.apache.org/spark for the versions in cas you encounter any error
ENV SPARK_VERSION=3.4.4 \
    HADOOP_VERSION=3 \
    SPARK_HOME=/opt/spark \
    PATH=/opt/spark/bin:/opt/spark/sbin:$PATH

# Install dependencies
RUN apk add --no-cache bash curl

# Download and extract Apache Spark
RUN curl -sL "https://downloads.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" | \
    tar -xz -C /opt && \
    mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} $SPARK_HOME

# Expose ports for Spark Master and Worker
EXPOSE 7077 8080

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
