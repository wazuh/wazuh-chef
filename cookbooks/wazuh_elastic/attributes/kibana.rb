default['wazuh-elastic']['kibana_server_host'] = '0.0.0.0'
default['wazuh-elastic']['kibana_server_port'] = 5601
default['wazuh-elastic']['kibana_elasticsearch_server_hosts'] = "http://#{node['wazuh-elastic']['elasticsearch_ip']}:#{node['wazuh-elastic']['elasticsearch_port']}"
default['wazuh-elastic']['kibana_wazuh_api_credentials'] = [ { id: "default", url: "https://localhost", port: "55000", username: "wazuh", password: "wazuh" } ]