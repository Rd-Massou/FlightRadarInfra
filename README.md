# Flight Radar Application Infrastructure

This project sets up a JupyterLab instance backed up by an Apache Spark cluster using Docker and Docker Compose. All images would run on a lightweight Alpine Linux image. The cluster includes one master node and a configurable number of worker nodes.

## Project Structure

The following files are included in the project:

- **Dockerfile.spark-node**: Defines a Docker image for a Spark node using Alpine Linux and `OpenJDK@1.8`.
- **Dockerfile.jupyterlab**: Defines a Docker image for JupyterLab using Alpine Linux and `Python@3.10.12`.
- **entrypoint.sh**: Entrypoint script to start Spark as a master or worker node based on the container role.
- **docker-compose.yml**: Docker Compose file to launch the Spark cluster with a master node and scalable worker nodes as well as the JupyterLab service.
- **.env**: Environment file to configure the number of Spark worker nodes.

## Prerequisites

- **Docker**: Install Docker by following the [official instructions](https://docs.docker.com/get-docker/).
- **Docker Compose**: Install Docker Compose if not included with Docker on your platform. Follow the [official instructions](https://docs.docker.com/compose/install/).

## Setup and Usage

### Step 1: Clone the Repository

Fork this [repository](https://github.com/Rd-Massou/FlightRadarInfra.git) and clone your fork to your local machine:

```bash
git clone <repository-fork-url>
cd FlightRadarInfra
```

### Step 2: Configure the Number of Workers
Edit the .env file to set the desired number of worker nodes for the Spark cluster.

```bash
WORKER_COUNT=2  # Adjust this to set the number of worker nodes
```
Alternatively, you can override this value at runtime (launch time) without modifying the .env file.

### Step 3: Launch the Spark Cluster
Launch the cluster with Docker Compose:
```bash
# Linux / Windows
docker-compose up -d
# MacOs
docker compose up -d
```
This will start the Spark master and the specified number of Spark worker nodes. The master node will be accessible at [http://localhost:8080](http://localhost:8080) on your local machine.

In case you have opted to runtime override of the number of worker nodes, you can use the following command:
```bash
# Linux / Windows
docker-compose up -d --scale spark-worker=3
# MacOs
docker compose up -d --scale spark-worker=3
```

### Step 4: Access the Spark Web UI
Once the cluster is running, you can access the Spark Master Web UI at:

Spark Master Web UI: [The Web UI](http://localhost:8080) provides an overview of the master node and registered worker nodes.

### Step 5: Shut Down the Cluster
To stop and remove the Spark cluster, run:

```bash
docker-compose down
```

## Testing the Spark Cluster
To test the cluster, go to [JupyterLab](http://localhost:8888). you can run the SparkExample notebook in the path notebooks/SparkExample.ipynb.

If you have a Spark app JAR ready to use (or get one [here](https://github.com/Rd-Massou/FlightRadarSpark.git) by cloning and running sbt assembly inside the dev container), copy it to the resources/jars folder and run the following command: 

```bash
docker exec -it spark-master spark-submit \
  --class com.example.batch.ExampleJobBatch \
  --master spark://spark-master:7077 \
  /resources/jars/sparkapp_2.12-1.0.jar \
  --in /resources/data/DUMMY_DATASET_CSV \
  --out /resources/data/DUMMY_DATASET_DELTA \
  --partition DAY=2024-10-11
```

## Customizing the Setup
Feel free to modify the .env file or the docker-compose.yml file to further customize the cluster setup as per your requirements.
