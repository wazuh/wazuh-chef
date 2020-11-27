# Cookbook Name:: filebeat
# Attribute:: files
# Author:: Wazuh <info@pwazuh.com>

default['filebeat']['alerts_template'] = 'wazuh-template.json' 
default['filebeat']['wazuh_module'] = "wazuh-filebeat-0.1.tar.gz"