# frozen_string_literal: true

# Cookbook Name:: opendistro
# Attributes:: api
# Author:: Wazuh <info@wazuh.com>

default['kibana']['wazuh_api_credentials'] = [
  {
    'id' => 'default',
    'url' => "https://#{node['network']['wazuh']['ip']}",
    'port' => "#{node['network']['wazuh']['port']}",
    'username' => 'wazuh-wui',
    'password' => 'wazuh-wui',
    'run_as' => true
  }
]
