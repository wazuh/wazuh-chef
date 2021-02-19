# frozen_string_literal: true

# Cookbook Name:: elastic-stack
# Attributes:: kibana.yml
# Author:: Wazuh <info@wazuh.com>

# Kibana configuration file
default['kibana']['yml'] = {
  'server' => {
    'host' => "#{node['network']['kibana']['ip']}",
    'port' => "#{node['network']['kibana']['port']}"
  },
  'elasticsearch' => {
    'hosts' => [
      "#{node['elastic']['yml']['host']}:#{node['elastic']['yml']['port']}"
    ],
    'password' => "#{node['network']['elasticsearch']['password']}"
  }
}
