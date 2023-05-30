#!/bin/bash

export DIR=$(pwd);

if [ ! -f "${DIR}/bin/build-image.sh" ]; then
  echo "There's no ./bin/build-image.sh file at current directory! please move to root project directory!";
  echo "Current directory: $DIR";
  exit 1;
elif [ ! -d "${DIR}/Charts" ]; then
  echo "There's no Charts folder at current directory! please move to root project directory!";
  echo "Current directory: $DIR";
  exit 1;
fi

source $DIR/bin/build-image.sh;

helm upgrade --install \
traveloka-takehome-test Charts \
--set image.tag=$TAG \
--set containerPort=$PORT \
--set service.port=$PORT

export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=traveloka-takehome-test,app.kubernetes.io/instance=traveloka-takehome-test" -o jsonpath="{.items[0].metadata.name}");
export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}");
kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT;