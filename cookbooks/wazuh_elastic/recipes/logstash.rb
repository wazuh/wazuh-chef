#
# Cookbook Name:: wazuh-elastic
# Recipe:: logstash_install

######################################################

package 'logstash' do
#  version node['wazuh-elastic']['elasticsearch_version']
end

template '01-ossec.conf' do
  path '/etc/logstash/conf.d/01-ossec.conf'
  source '01-ossec.conf.erb'
  owner 'root'
  group 'root'
  # variables({
  #   :elasticsearch_cluster_name => node['wazuh-elk']['elasticsearch_cluster_name'],
  #   :elasticsearch_node_name => node['wazuh-elk']['elasticsearch_node_name']
  # })
  notifies :restart, 'service[logstash]', :delayed
end

<<<<<<< HEAD
template 'elastic-ossec-template.json' do
  path '/etc/logstash/wazuh-elastic5-template.json'
  source 'wazuh-elastic5-template.json.erb'
  owner 'root'
  group 'root'
  # variables({
  #   :elasticsearch_cluster_name => node['wazuh-elk']['elasticsearch_cluster_name'],
  #   :elasticsearch_node_name => node['wazuh-elk']['elasticsearch_node_name']
  # })
  notifies :restart, 'service[logstash]', :delayed
end

ssl = Chef::EncryptedDataBagItem.load('wazuh_secrets', 'logstash_certificate')

file '/etc/logstash/logstash-forwarder.crt' do
=======
ssl = Chef::EncryptedDataBagItem.load('wazuh_secrets', 'logstash_certificate')

file '/etc/logstash/logstash.crt' do
>>>>>>> d3e691bba7f9a6a500c6722eb8e57a4110600cbb
  mode '0544'
  owner 'root'
  group 'root'
  content ssl['logstash_certificate'].to_s
  action :create
  notifies :restart, 'service[logstash]', :delayed
end

<<<<<<< HEAD
file '/etc/logstash/logstash-forwarder.key' do
=======
file '/etc/logstash/logstash.key' do
>>>>>>> d3e691bba7f9a6a500c6722eb8e57a4110600cbb
  mode '0544'
  owner 'root'
  group 'root'
  content ssl['logstash_certificate_key'].to_s
  action :create
  notifies :restart, 'service[logstash]', :delayed
end

service 'logstash' do
  action [:enable, :start]
end
