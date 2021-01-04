#! /usr/bin/env bash
set -e

echo "Get into feature-cookbooks"
cd $HOME/wazuh-chef && \
git checkout feature-cookbooks && \
git pull origin feature-cookbooks

#echo "Installing dependencies"
#bundle install

export PLATFORM="centos"
export RELEASE="8"
export IMAGE="centos:8"
export RUN_COMMAND="/sbin/init"

cd kitchen

echo "List kitchen instances"
kitchen list

/bin/bash 

#echo "Kitchen create manager..."
#kitchen create wazuh-server-$PLATFORM-$RELEASE
#
#manager_ip="$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' `docker ps | awk '{print $NF}' | grep wazuh-server`)"
#export MANAGER_IP=$manager_ip
#echo "Getting Wazuh manager IP: $manager_ip"
#
#echo "Kitchen converge manager ..."
#kitchen converge wazuh-manager-$PLATFORM-$RELEASE
#
#echo "Kitchen create agent..."
#kitchen create wazuh-agent-$PLATFORM-$RELEASE
#
#echo "Kitchen converge agent..."
#kitchen converge wazuh-agent-$PLATFORM-$RELEASE