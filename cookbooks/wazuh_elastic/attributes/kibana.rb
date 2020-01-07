default['wazuh-elastic']['kibana_server_host'] = '0.0.0.0'
default['wazuh-elastic']['kibana_server_port'] = '5601'
default['wazuh-elastic']['kibana_elasticsearch_server_hosts'] = "http://#{node['wazuh-elastic']['elasticsearch_ip']}:#{node['wazuh-elastic']['elasticsearch_port']}"
default['wazuh-elastic']['kibana_wazuh_api_credentials'] = [ { id: "production", url: "http://172.23.0.101", port: "55000", user: "test", password: "test2" } ]