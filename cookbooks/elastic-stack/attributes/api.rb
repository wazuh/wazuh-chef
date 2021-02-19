# frozen_string_literal: true

# Cookbook Name:: elastic-stack
# Attributes:: api
# Author:: Wazuh <info@wazuh.com>

default['kibana']['wazuh_api_credentials'] = [
  {
    'id' => 'default',
    'url' => "https://#{node['network']['elasticsearch']['ip']}",
    'port' => 55000,
    'username' => 'wazuh-wui',
    'password' => 'wazuh-wui',
    'run_as' => true
  }
]
