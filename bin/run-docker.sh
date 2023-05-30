#!/bin/bash

export DIR=$(pwd);

if [ ! -f "${DIR}/bin/build-image.sh" ]; then
  echo "There's no ./bin/build-image.sh file at current directory! please move to root project directory!";
  echo "Current directory: $DIR";
  exit 1;
elif [ ! -f "${DIR}/docker-compose.yml" ]; then
  echo "There's no docker-compose.yml file at current directory! please move to root project directory!";
  echo "Current directory: $DIR";
  exit 1;
fi

source $DIR/bin/build-image.sh;

echo "Running Docker Compose...";
docker-compose up -d;

echo -e "\nvisit: http://${HOST}:${HOST_PORT}"