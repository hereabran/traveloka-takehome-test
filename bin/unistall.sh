#!/bin/bash

(command -v git &> /dev/null && command -v docker &> /dev/null && command -v docker-compose &> /dev/null && command -v kubectl &> /dev/null && command -v helm &> /dev/null) || {
  echo "command git OR docker OR docker-compose OR kubectl OR helm are not found, please install the necessary binaries to run this program!";
  exit 1;
}

helm uninstall traveloka-takehome-test;
helm uninstall nginx-ingress;