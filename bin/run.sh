#!/bin/bash

export DIR=$(pwd);

source $DIR/bin/build-image.sh;

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

echo -e "\n${Cyan}Installing/Upgrading traveloka-takehome-test Release...${Color_Off}";
helm upgrade --install \
traveloka-takehome-test charts \
--set image.repository=$IMAGE_NAME \
--set image.tag=$TAG \
--set containerPort=$CONTAINER_PORT \
--set service.port=$CONTAINER_PORT \
--set ingress.enabled=true \
--set ingress.className=nginx && \
echo -e "\n${Green}Install/Upgrade traveloka-takehome-test Release succeeded.${Color_Off}" || \
echo -e "\n${Red}Install/Upgrade traveloka-takehome-test Release failed.${Color_Off}";
