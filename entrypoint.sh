#!/bin/bash

SPARK_MASTER_URL="spark://spark-master:7077"

if [[ "$SPARK_ROLE" == "master" ]]; then
    echo "Starting Spark Master..."
    $SPARK_HOME/bin/spark-class org.apache.spark.deploy.master.Master --host spark-master --port 7077 --webui-port 8080
elif [[ "$SPARK_ROLE" == "worker" ]]; then
    echo "Starting Spark Worker..."
    $SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker $SPARK_MASTER_URL
else
    echo "SPARK_ROLE not specified. Please set it to 'master' or 'worker'."
    exit 1
fi

# Keep the container running
tail -f /dev/null
