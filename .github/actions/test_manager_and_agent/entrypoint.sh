#! /usr/bin/env bash
set -e

echo "Env var value: IMAGE "
echo $IMAGE
echo "Env var value: PLATFORM "
echo $PLATFORM
echo "Env var value: RELEASE"
echo $RELEASE

cd kitchen

echo "Installing dependencies"
chef env --chef-license accept
chef gem install kitchen-docker -v 2.3 
chef gem install test-kitchen 
chef gem install kitchen-inspec

echo "Install docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

echo "Kitchen create manager..."
kitchen create wazuh-server-$PLATFORM-$RELEASE

manager_ip="$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' `docker ps | awk '{print $NF}' | grep wazuh-server`)"
export MANAGER_IP=$manager_ip
echo "Getting Wazuh manager IP: $manager_ip"

echo "Kitchen converge manager ..."
kitchen converge wazuh-manager-$PLATFORM-$RELEASE

echo "Sleeping while the agent is starting"
sleep 15

echo "Kitchen create agent..."
kitchen create wazuh-agent-$PLATFORM-$RELEASE

echo "Kitchen converge agent..."
kitchen converge wazuh-agent-$PLATFORM-$RELEASE

#echo "Change IP manager address in ossec.conf..."
#kitchen exec wazuh-agent-$PLATFORM-$RELEASE -c "sed -i \"s/<address>*<\/address>/<address>${manager_ip}<\/address>/g\" ossec.conf" 
#
#echo "Connect agent with manager"
#kitchen converge