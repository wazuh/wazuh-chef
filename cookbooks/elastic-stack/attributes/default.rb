# Cookbook Name:: elastic-stack
# Attributes:: default
# Author:: Wazuh <info@wazuh.com>

# Elastic paths
default['elastic']['config_path'] = "/etc/elasticsearch"

# Kibana paths
default['kibana']['package_path'] = "/usr/share/kibana"
default['kibana']['config_path'] = "/etc/kibana"

#Try yo rename this to path.rb and install all