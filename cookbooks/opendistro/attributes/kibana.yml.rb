# frozen_string_literal: true

# Cookbook Name:: opendistro
# Attributes:: kibana.yml
# Author:: Wazuh <info@wazuh.com>

# Kibana-oss configuration file

default['kibana']['yml'] = {
  'server' => {
    'host' => "#{node['network']['kibana']['ip']}",
    'port' => "#{node['network']['kibana']['port']}",
  },
  'elasticsearch' => {
    'hosts' => [
      "https://#{node['network']['elasticsearch']['ip']}:#{node['network']['elasticsearch']['port']}"
    ]
  }
}
