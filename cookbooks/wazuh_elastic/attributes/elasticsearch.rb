# jvm.options configuration

default['wazuh-elastic']['elasticsearch_memmory'] = "1g"

# Cluster configuration

default['wazuh-elastic']['elasticsearch_cluster_name'] = 'es-wazuh'
default['wazuh-elastic']['elasticsearch_node_name'] = 'es-node-01'
default['wazuh-elastic']['elasticsearch_node_master'] = 'true'
default['wazuh-elastic']['elasticsearch_node_data'] = 'true'
default['wazuh-elastic']['elasticsearch_node_ingest'] = 'true'
default['wazuh-elastic']['elasticsearch_node_max_local_storage_nodes'] = '1' 
default['wazuh-elasticsearch']['elasticsearch_cluster_remote_connect'] = "true"

# General configuration

default['wazuh-elastic']['elasticsearch_path_data'] = "/var/lib/elasticsearch"
default['wazuh-elastic']['elasticsearch_path_logs'] = "/var/log/elasticsearch"
default['wazuh-elastic']['elasticsearch_port'] = 9200
default['wazuh-elastic']['elasticsearch_ip'] = '172.19.0.211'
default['wazuh-elastic']['elasticsearch_discovery_option'] = 'discovery.type: single-node'
default['wazuh-elastic']['elasticsearch_cluster_initial_master_nodes'] = "#cluster.initial_master_nodes: ['es-node-01']"

