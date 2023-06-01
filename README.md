![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)

# Traveloka Take Home Test (ABran)

This repository contains a simple Hello World HTTP application that can be deployed as a Docker container and run locally with Kubernetes. It fulfills the requirements stated in the task, including packaging the application in a Docker container, deploying it with Kubernetes, exposing the application on port 80, tuning the pods resource requests and limits, load testing with Locust, and providing automation scripts for setup.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Application Setup](#application-setup)
- [Running the Application with Kubernetes](#running-the-application-with-kubernetes)
- [Load Testing with Locust](#load-testing-with-locust)
- [Functional Testing with Pytest](#functional-testing-with-pytest)
- [How to Rollback to v1](#how-to-rollback-to-v1)
- [How to Scaling up/down the Application Horizontally](#how-to-scaling-up-down-the-application-horizontally)
- [Automation Scripts](#automation-scripts)
- [Rationale, Assumptions, Limitations, and Potential Improvements](#rationale-assumptions-limitations-and-potential-improvements)

## Prerequisites

#### Before running the application, please ensure you have the following software installed:

- `Python 3.9` & `pip` (for Locust load test, pytest and alembic DB Migration)
- Docker
- Kubernetes (with a running cluster)
- Helm v3
- `kubectl` command-line tool

## Application Setup

1. Clone the repository and navigate to the task directory:
```bash
git clone https://github.com/hereabran/traveloka-takehome-test.git

cd traveloka-takehome-test/solutions/task1
```

2. Export necessary variables:
```bash
export DIR=$(pwd)
export IMAGE_NAME=traveloka-takehome-test
export CONTAINER_PORT=8080
export TAG=v1
```

3. Build the Docker image:
```bash
docker build -t "${IMAGE_NAME}:${TAG}" --build-arg PORT=$CONTAINER_PORT $DIR
```

## Running the Application with Kubernetes

1. Running the application and exposing the application on port 80, which maps to the application's port 8080:
```bash
helm upgrade --install \
traveloka-takehome-test charts \
--set image.repository=$IMAGE_NAME \
--set image.tag=$TAG \
--set containerPort=$CONTAINER_PORT \
--set service.port=80 \
```

2. Running the application with NGINX Ingress Controller
```bash
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm upgrade --install nginx-ingress nginx-stable/nginx-ingress --set rbac.create=true
```
```bash
helm upgrade --install \
traveloka-takehome-test charts \
--set image.repository=$IMAGE_NAME \
--set image.tag=$TAG \
--set containerPort=$CONTAINER_PORT \
--set service.port=$CONTAINER_PORT \
--set ingress.enabled=true \
--set ingress.className=nginx
```

3. Uninstall helm release:
```bash
helm uninstall traveloka-takehome-test
helm uninstall nginx-ingress
```

## Load Testing with Locust

1. Install Locust via `pip`
```bash
pip install locust
```

2. Run locust
```bash
locust -f app/tests/locustfile.py
```

3. Open Locust Web UI & set user concurent
```bash
open http://localhost:8089/
```

## Automation Scripts

Automation scripts are provided to set up the solution from scratch. The following scripts are available:

- `./bin/build-image.sh`: Builds the Docker image.
- `./bin/run.sh`: Deploys the application with Kubernetes (NGINX Ingress Controller).
- `./bin/uninstall.sh`: Uninstall Helm Release to clean up environment.

You can run these scripts to automate the setup process simply by using the `bash` command.

## Rationale, Assumptions, Limitations, and Potential Improvements

### Rationale:

- The project aims to showcase a simple Hello World HTTP application that can be deployed using Docker and Kubernetes. It demonstrates the process of containerizing an application, deploying it with Kubernetes, and performing load testing with Locust.
- Docker allows for packaging the application and its dependencies into a single container, ensuring consistency and portability across different environments.
- Kubernetes provides an orchestration platform to deploy, manage, and scale the application containers effectively.
- Load testing with Locust helps evaluate the application's performance and determine its scalability under different user loads.

### Assumptions:

- It is assumed that the user has a basic understanding of Docker, Kubernetes, and Helm. Knowledge of Python, pip, and Locust is also required for load testing.
- The user already has a Kubernetes cluster set up and has the necessary permissions to deploy applications and resources within the cluster.
- The user is running the setup on a Unix-like operating system (e.g., Linux, macOS) with bash available.

### Limitations:

- The provided application is a simple Hello World HTTP application and does not represent a real-world production application with complex functionality.
- The Docker image build assumes a specific Python version (3.9) and may not be compatible with other versions without modification.
- The deployment and load testing processes described in the repository are simplified and may not cover all aspects of a production-ready setup, such as security configurations, monitoring, and logging.
- The provided automation scripts are basic and may not handle all possible edge cases or error scenarios.

### Potential Improvements:

- Expand the application to include more complex functionality to better reflect a real-world use case.
- Add unit tests and integration tests to ensure the application's reliability and functionality.
- Include configuration options for different database backends or external services that the application may require.
- Implement logging and monitoring solutions to gain insights into the application's behavior and performance in production.
- Enhance the automation scripts to handle different deployment environments and provide more flexibility in configuration.
- Utilize a CI/CD pipeline to automate the build, deployment, and testing processes for increased efficiency and consistency.
- Implement rolling updates and zero-downtime deployments to ensure continuous availability of the application during updates.
- Integrate with a centralized error tracking system to receive notifications and insights into application errors and exceptions.