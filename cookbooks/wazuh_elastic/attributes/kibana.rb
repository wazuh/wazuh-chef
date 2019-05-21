default['wazuh-elastic']['kibana_host'] = '0.0.0.0'
default['wazuh-elastic']['kibana_port'] = '5601'
default['wazuh-elastic']['kibana_elasticsearch_server'] = "http://#{node['wazuh-elastic']['elasticsearch_ip']}:#{node['wazuh-elastic']['elasticsearch_port']}"