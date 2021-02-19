# frozen_string_literal: true

# Cookbook Name:: elastic-stack
# Attributes:: elasticsearch.yml
# Author:: Wazuh <info@wazuh.com>

# Elasticsearch configuration file
default['elastic']['yml'] = {
  'node_name' => 'es-node-01',
  'cluster' => {
    'name' => 'elastic_cluster',
    'initial_master_nodes' => [
      'es-node-01'
    ]
  },
  'path' => {
    'data' => '/var/lib/elasticsearch',
    'logs' => '/var/log/elasticsearch'
  },
  'host' => "#{node['network']['elasticsearch']['ip']}",
  'port' => "#{node['network']['elasticsearch']['port']}"
}
