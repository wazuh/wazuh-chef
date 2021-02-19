# Cookbook Name:: filebeat
# Attribute:: paths
# Author:: Wazuh <info@wazuh.com>

default['filebeat']['config_path'] = '/etc/filebeat'
default['filebeat']['wazuh_module_path'] = '/usr/share/filebeat/module'
default['filebeat']['certs_path'] = "#{node['filebeat']['config_path']}/certs"
