# Cookbook Name:: filebeat-oss
# Attribute:: files
# Author:: Wazuh <info@wazuh.com>

default['filebeat']['alerts_template'] = 'wazuh-template.json' 
default['filebeat']['wazuh_module'] = "wazuh-filebeat-0.1.tar.gz"