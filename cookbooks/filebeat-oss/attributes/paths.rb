# Cookbook Name:: filebeat-oss
# Attribute:: paths
# Author:: Wazuh <info@wazuh.com>

default['filebeat']['config_path'] = '/etc/filebeat'
default['filebeat']['wazuh_module_path'] = '/usr/share/filebeat/module'
default['filebeat']['certs_path'] = "#{node['filebeat']['config_path']}/certs"
default['elastic']['config_path'] = "/etc/elasticsearch"
default['elastic']['certs_path'] = "#{node['elastic']['config_path']}/certs"