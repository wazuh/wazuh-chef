# frozen_string_literal: true

# Cookbook Name:: opendistro
# Attributes:: searchguard.yml
# Author:: Wazuh <info@wazuh.com>

# Searchguard configuraion file

default['search_guard']['yml'] = {
  'nodes' => {
    'elasticsearch' => {
      'ip' => [
        (node['network']['elasticsearch']['ip']).to_s
      ]
    },
    'kibana' => {
      'ip' => [
        (node['network']['kibana']['ip']).to_s
      ]
    }
  }
}
