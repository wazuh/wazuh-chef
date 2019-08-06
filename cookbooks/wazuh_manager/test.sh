ubuntu_manager_ip="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' `docker ps | awk '{print $NF}' | grep  ubuntu | grep manager`)"


development_agent_path="$COOKBOOKS_HOME/wazuh_agent/test/environments/development.json"
template=".template"

sed -i 's/manager-master.wazuh-test.com/'${ubuntu_manager_ip}'/g' $development_agent_path
