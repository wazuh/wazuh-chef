#! /usr/bin/env bash
set -e

echo "Env var value: PLATFORM "
echo $PLATFORM
echo "Env var value: RELEASE"
echo $RELEASE

cd kitchen

echo "Installing dependencies"
chef env --chef-license accept
chef gem install kitchen-docker 
chef gem install test-kitchen
chef gem install kitchen-inspec
chef gem install inspec

echo "Install docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

echo "Kitchen create manager..."
kitchen create wazuh-server-$PLATFORM-$RELEASE

echo "Getting wazuh-server-$PLATFORM-$RELEASE container ID"
container_id="$(docker ps -aqf "name=wazuh-server-$PLATFORM-$RELEASE$")"

echo "Getting Wazuh managers IP"
manager_ip="$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container_id)"

echo "wazuh-manager IP"
echo $manager_ip
MANAGER_IP=$manager_ip

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