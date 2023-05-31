#!/bin/bash

export DIR=$(pwd);

if [ ! -f "${DIR}/bin/build-image.sh" ]; then
  echo "There's no ./bin/build-image.sh file at current directory! please move to root project directory!";
  echo "Current directory: $DIR";
  exit 1;
elif [ ! -d "${DIR}/charts" ]; then
  echo "There's no charts folder at current directory! please move to root project directory!";
  echo "Current directory: $DIR";
  exit 1;
fi

source $DIR/bin/build-image.sh;

echo -e "\nAdding NGINX Ingress Controller helm repository...\n";
helm repo add nginx-stable https://helm.nginx.com/stable;

echo -e "\nRunning helm repo update...\n";
helm repo update;

helm upgrade --install nginx-ingress nginx-stable/nginx-ingress --set rbac.create=true;

helm upgrade --install \
traveloka-takehome-test charts \
--set image.repository=$IMAGE_NAME \
--set image.tag=$TAG \
--set containerPort=$CONTAINER_PORT \
--set service.port=$CONTAINER_PORT \
--set ingress.enabled=true \
--set ingress.className=nginx
