# frozen_string_literal: true

# Cookbook Name:: elastic-stack
# Attributes:: paths
# Author:: Wazuh <info@wazuh.com>

# Elastic paths
default['elastic']['config_path'] = '/etc/elasticsearch'
default['elastic']['package_path'] = '/usr/share/elasticsearch'
default['elastic']['certs_path'] = "#{node['elastic']['config_path']}/certs"

# Kibana paths
default['kibana']['package_path'] = '/usr/share/kibana'
default['kibana']['config_path'] = '/etc/kibana'
default['kibana']['certs_path'] = "#{node['kibana']['config_path']}/certs"
default['kibana']['data_path'] = "#{node['kibana']['package_path']}/data"
default['kibana']['plugins_path'] = "#{node['kibana']['package_path']}/plugins"
