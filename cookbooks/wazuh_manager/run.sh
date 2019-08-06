#!/bin/bash

echo "Kitchen is creating the new instances"
kitchen create ubuntu

echo "Getting Wazuh managers IPs to the agents"
ubuntu_manager_ip="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' `docker ps | awk '{print $NF}' | grep  ubuntu | grep manager`)"


development_agent_path="$COOKBOOKS_HOME/wazuh_agent/test/environments/development.json"
template=".template"

cp "$development_agent_path$template" "$development_agent_path"

echo "Assigning Wazuh managers IPs to the corresponding agents."
sed -i 's/manager-client.wazuh-test.com//g' $development_agent_path
sed -i 's/manager-master.wazuh-test.com/'${ubuntu_manager_ip}'/g' $development_agent_path


echo "Kitchen is converging ..."
kitchen converge ubuntu

echo "Kitchen is testing ..."
kitchen verify ubuntu

echo "Getting default things back"
cp "$development_agent_path$template" "$development_agent_path"
