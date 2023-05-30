#!/bin/bash

(command -v git &> /dev/null && command -v docker &> /dev/null && command -v kubectl &> /dev/null && command -v helm &> /dev/null) || {
  echo "command git OR docker OR kubectl OR helm are not found, please install the necessary binaries to run this program!";
  exit 1;
}

export DIR=$(pwd);

if [ ! -f "${DIR}/Dockerfile" ]; then
  echo "There's no Dockerfile at current directory! please move to root project directory!";
  echo "Current directory: $DIR";
  exit 1;
fi

export IMAGE_NAME=traveloka-takehome-test;
export CONTAINER_PORT=8080
export HOST_PORT=80
export HOST=localhost

export GIT_BRANCH=$(git branch --show-current)
if [ $GIT_BRANCH == "solutions/task1" ]; then
  export TAG=v1;
elif [ $GIT_BRANCH == "solutions/task2" ]; then
  export TAG=v2;
else
  echo "Please git checkout to either branch 'solutions/task1' or 'solutions/task2'";
  exit 1;
fi

echo -e "Building docker image (${IMAGE_NAME}:${TAG})...\n";
docker build -t "${IMAGE_NAME}:${TAG}" --build-arg PORT=$CONTAINER_PORT $DIR;

echo -e "\nBuild docker image completed.";