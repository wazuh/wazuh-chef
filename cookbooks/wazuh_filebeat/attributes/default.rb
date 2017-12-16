#
# Cookbook Name:: filebeat
# Attribute:: default
# Author:: Wazuh <info@pwazuh.com>
#
#
#

default['filebeat']['package_name'] = 'filebeat'
default['filebeat']['service_name'] = 'filebeat'
default['filebeat']['logstash_servers'] = 'indexer.wazuh.com:5000'
default['filebeat']['timeout'] = 15
default['filebeat']['config_path'] = '/etc/filebeat/filebeat.yml'
<<<<<<< HEAD
default['filebeat']['ssl_ca'] = '/etc/filebeat/logstash_certificate.crt'
=======
default['filebeat']['certificate_authorities'] = '/etc/filebeat/logstash_certificate.crt'
default['filebeat']['certificate'] = '/etc/filebeat/logstash-forwarder.crt'
default['filebeat']['key'] = '/etc/filebeat/logstash-forwarder.key'
>>>>>>> d3e691bba7f9a6a500c6722eb8e57a4110600cbb
