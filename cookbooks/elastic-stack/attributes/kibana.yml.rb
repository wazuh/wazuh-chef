# frozen_string_literal: true

# Cookbook Name:: elastic-stack
# Attributes:: kibana.yml
# Author:: Wazuh <info@wazuh.com>

# Kibana configuration file
default['kibana']['yml'] = {
  'server' => {
    'host' => '0.0.0.0',
    'port' => 5601
  },
  'elasticsearch' => {
    'hosts' => [
      "http://#{node['elastic']['yml']['network']['host']}:#{node['elastic']['yml']['http']['port']}"
    ]
  }
}
