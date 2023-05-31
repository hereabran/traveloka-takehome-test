#!/bin/bash

DIR=$(pwd);

source $DIR/bin/build-image.sh;

REPLICAS=${1:-1}
re='^[0-9]+$'
if ! [[ $REPLICAS =~ $re ]]; then
  echo -e "${Red}error: Argument is not a number, pass the argument with the number of desired replicas!${Color_Off}" >&2;
  exit 1;
elif [[ $REPLICAS -lt 1 || $REPLICAS -gt 10 ]]; then
  echo -e "${Red}error: Pass the argument with the number of desired replicas between 1 and 10!${Color_Off}" >&2;
  exit 1;
fi

if [ ! -f "${DIR}/bin/build-image.sh" ]; then
  echo -e "${Red}\nThere's no ./bin/build-image.sh file at current directory! please move to root project directory!${Color_Off}";
  echo -e "${Cyan}Current directory: $DIR${Color_Off}";
  exit 1;
elif [ ! -d "${DIR}/charts" ]; then
  echo -e "${Red}\nThere's no charts folder at current directory! please move to root project directory!${Color_Off}";
  echo -e "${Cyan}Current directory: $DIR${Color_Off}";
  exit 1;
fi

echo -e "\n${Cyan}Adding NGINX Ingress Controller helm repository...${Color_Off}";
helm repo add nginx-stable https://helm.nginx.com/stable;

echo -e "\n${Cyan}Running helm repo update...${Color_Off}";
helm repo update

echo -e "\n${Cyan}Installing/Upgrading NGINX Ingress Controller Release...${Color_Off}";
helm upgrade --install nginx-ingress nginx-stable/nginx-ingress --set rbac.create=true && \
echo -e "\n${Green}Install/Upgrade NGINX Ingress Release succeeded.${Color_Off}" || \
echo -e "\n${Red}Install/Upgrade NGINX Ingress Release failed.${Color_Off}";

# PostgreSQL variables
export DATABASE_USERNAME=traveloka-takehome-test
export DATABASE_PASSWORD=traveloka1231
export DATABASE_HOST=postgresql
export DATABASE_NAME=traveloka-takehome-test
export POSTGRES_PASSWORD=Traveloka1234561

echo -e "\n${Cyan}Installing/Upgrading PostgreSQL Release...${Color_Off}";
helm upgrade --install \
postgresql oci://registry-1.docker.io/bitnamicharts/postgresql \
--set global.postgresql.auth.postgresPassword=$POSTGRES_PASSWORD \
--set global.postgresql.auth.username=$DATABASE_USERNAME \
--set global.postgresql.auth.password=$DATABASE_PASSWORD \
--set global.postgresql.auth.database=$DATABASE_NAME && \
echo -e "\n${Green}Install/Upgrade PostgreSQL Release succeeded.${Color_Off}" || \
echo -e "\n${Red}Install/Upgrade PostgreSQL Release failed.${Color_Off}";

echo -e "\n${Cyan}Installing/Upgrading traveloka-takehome-test Release...${Color_Off}";
helm upgrade --install \
traveloka-takehome-test charts \
--set replicaCount=$REPLICAS \
--set image.repository=$IMAGE_NAME \
--set image.tag=$TAG \
--set containerPort=$CONTAINER_PORT \
--set service.port=$CONTAINER_PORT \
--set env.DATABASE_USERNAME=$DATABASE_USERNAME \
--set env.DATABASE_PASSWORD=$DATABASE_PASSWORD \
--set env.DATABASE_HOST=$DATABASE_HOST \
--set env.DATABASE_NAME=$DATABASE_NAME \
--set ingress.enabled=true \
--set ingress.className=nginx && \
echo -e "\n${Green}Install/Upgrade traveloka-takehome-test Release succeeded.${Color_Off}" || \
echo -e "\n${Red}Install/Upgrade traveloka-takehome-test Release failed.${Color_Off}";
