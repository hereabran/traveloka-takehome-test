#!/bin/bash

# Colors
export Color_Off='\033[0m' # Text Reset
export Red='\033[0;31m' # Red
export Green='\033[0;32m' # Green
export Cyan='\033[0;36m' # Cyan

(command -v git &> /dev/null && command -v docker &> /dev/null && command -v kubectl &> /dev/null && command -v helm &> /dev/null) || {
  echo -e "${Red}Command git OR docker OR kubectl OR helm are not found, please install the necessary binaries to run this program!${Color_Off}";
  exit 1;
}

export DIR=$(pwd);

if [ ! -f "${DIR}/Dockerfile" ]; then
  echo -e "${Red}There's no Dockerfile at current directory! please move to root project directory!${Color_Off}";
  echo -e "${Cyan}Current directory: $DIR${Color_Off}";
  exit 1;
fi

# Docker variables
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
  echo -e "${Red}Please git checkout to either branch 'solutions/task1' or 'solutions/task2'";
  exit 1;
fi

echo -e "${Cyan}Building docker image (${IMAGE_NAME}:${TAG})...\n${Color_Off}";
docker build -t "${IMAGE_NAME}:${TAG}" \
--build-arg PORT=$CONTAINER_PORT $DIR && \
echo -e "\n${Green}Build docker image completed.${Color_Off}" || \
echo -e "\n${Red}Build docker image failed.${Color_Off}"