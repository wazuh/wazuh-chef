# Cookbook Name:: filebeat
# Attribute:: default
# Author:: Wazuh <info@pwazuh.com>

default['filebeat']['elasticsearch_server_ip'] = [
    "http://0.0.0.0:9200"
]
default['filebeat']['config_path'] = '/etc/filebeat'
default['filebeat']['alerts_template'] = 'wazuh-template.json' 
default['filebeat']['wazuh_module'] = "wazuh-filebeat-0.1.tar.gz"
default['filebeat']['wazuh_module_path'] = '/usr/share/filebeat/module'