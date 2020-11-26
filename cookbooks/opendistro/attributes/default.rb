# Cookbook Name:: opendistro
# Attributes:: default
# Author:: Wazuh <info@wazuh.com>

# Elastic paths
default['elastic']['config_path'] = "/etc/elasticsearch"
default['elastic']['package_path'] = "/usr/share/elasticsearch"
default['elastic']['plugins_path'] = "#{node['elastic']['package_path']}/plugins"

# Kibana paths
default['kibana']['package_path'] = "/usr/share/kibana"
default['kibana']['config_path'] = "/etc/kibana"

# Searchguard paths
default['searchguard']['config_path'] = "/etc/searchguard"

