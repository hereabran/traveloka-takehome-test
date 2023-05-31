#!/bin/bash

# Colors
Color_Off='\033[0m' # Text Reset
Red='\033[0;31m' # Red
Green='\033[0;32m' # Green
Cyan='\033[0;36m' # Cyan

(command -v git &> /dev/null && command -v docker &> /dev/null && command -v kubectl &> /dev/null && command -v helm &> /dev/null) || {
  echo -e "${Red}Command git OR docker OR kubectl OR helm are not found, please install the necessary binaries to run this program!${Color_Off}";
  exit 1;
}

echo -e "\n${Cyan}Uninstalling traveloka-takehome-test Release...${Color_Off}";
helm uninstall traveloka-takehome-test;

echo -e "\n${Cyan}Uninstalling PostgreSQL Release...${Color_Off}";
helm uninstall postgresql;

echo -e "\n${Cyan}Uninstalling NGINX Ingress Release...${Color_Off}";
helm uninstall nginx-ingress;