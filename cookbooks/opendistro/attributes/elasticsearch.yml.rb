# frozen_string_literal: true

# Cookbook Name:: opendistro
# Attributes:: elasticsearch.yml
# Author:: Wazuh <info@wazuh.com>

# Elasticsearch-oss configuration file

default['elastic']['yml'] = {
  'network' => {
    'host' => "#{node['network']['elasticsearch']['ip']}"
  },
  'http' => {
    'port' => "#{node['network']['elasticsearch']['port']}",
  },
  'node' => {
    'name' => 'odfe-node-1'
  },
  'cluster' => {
    'initial_master_nodes' => [
      'odfe-node-1'
    ]
  }
}
