#
# Cookbook Name:: filebeat
# Attribute:: default
# Author:: Wazuh <info@pwazuh.com>
#
#
#
default['filebeat']['package_name'] = 'filebeat'
default['filebeat']['service_name'] = 'filebeat'
default['filebeat']['elasticsearch_server_ip'] = "localhost"
default['filebeat']['timeout'] = 15
default['filebeat']['config_path'] = '/etc/filebeat/filebeat.yml'
default['filebeat']['elasticsearch_server_port'] = 9200
