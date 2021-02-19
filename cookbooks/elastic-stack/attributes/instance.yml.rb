# frozen_string_literal: true

# Cookbook Name:: elastic-stack
# Attributes:: instance.yml
# Author:: Wazuh <info@wazuh.com>

# Instance configuration file
default['instance']['yml'] = {
  'elasticsearch_ip' => "#{node['network']['elasticsearch']['ip']}",
  'filebeat_ip' => "#{node['network']['wazuh']['ip']}",
  'kibana_ip' => "#{node['network']['kibana']['ip']}"
}
