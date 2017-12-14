#
# Cookbook Name:: filebeat
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

package 'filebeat'

template node['filebeat']['config_path'] do
  source 'filebeat.yml.erb'
  owner 'root'
  group 'root'
  mode '0640'
  variables(:servers => node['filebeat']['logstash_servers'])
  notifies :restart, "service[#{node['filebeat']['service_name']}]"
end

ssl = Chef::EncryptedDataBagItem.load('wazuh_secrets', 'logstash_certificate')

file '/etc/filebeat/logstash_certificate.crt' do
  mode '0544'
  owner 'root'
  group 'root'
  content ssl['logstash_certificate'].to_s
  action :create
  notifies :restart, "service[#{node['filebeat']['service_name']}]", :delayed
end

file '/etc/filebeat/logstash-forwarder.crt' do
  mode '0544'
  owner 'root'
  group 'root'
  content ssl['logstash_certificate'].to_s
  action :create
  notifies :restart, "service[#{node['filebeat']['service_name']}]", :delayed
end

file '/etc/filebeat/logstash-forwarder.key' do
  mode '0544'
  owner 'root'
  group 'root'
  content ssl['logstash_certificate_key'].to_s
  action :create
  notifies :restart, "service[#{node['filebeat']['service_name']}]", :delayed
end

service node['filebeat']['service_name'] do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end
