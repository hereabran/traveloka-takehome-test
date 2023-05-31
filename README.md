![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)

# Traveloka Take Home Test (ABran)

This repository contains a simple Hello World HTTP application that can be deployed as a Docker container and run locally with Kubernetes. It fulfills the requirements stated in the task, including packaging the application in a Docker container, deploying it with Kubernetes, exposing the application on port 80, tuning the pods resource requests and limits, load testing with Locust, and providing automation scripts for setup.

## Table of Contents
- [Prerequisites](#Prerequisites)
- [Application Setup](#Application%20Setup)
- [Running the Application with Kubernetes](#Running%20the%20Application%20with%20Kubernetes)
- [Load Testing with Locust](#Load%20Testing%20with%20Locust)
- [Automation Scripts](#Automation%20Scripts)
- [Rationale, Assumptions, Limitations, and Potential Improvements](#Rationale,%20Assumptions,%20Limitations,%20and%20Potential%20Improvements)

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

You can run these scripts to automate the setup process.

## Rationale, Assumptions, Limitations, and Potential Improvements

