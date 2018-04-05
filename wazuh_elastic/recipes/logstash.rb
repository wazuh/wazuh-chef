#
# Cookbook Name:: wazuh-elastic
# Recipe:: logstash_install

######################################################

case node['platform_family']
when 'debian'
  package 'logstash' do
    version '1:'+node['wazuh-elastic']['elastic_stack_version']+'-1'
  end
when 'rhel'
  package 'logstash' do
    version node['wazuh-elastic']['elastic_stack_version']
  end
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

ssl = Chef::EncryptedDataBagItem.load('wazuh_secrets', 'logstash_certificate')

file '/etc/logstash/logstash.crt' do
  mode '0544'
  owner 'root'
  group 'root'
  content ssl['logstash_certificate'].to_s
  action :create
  notifies :restart, 'service[logstash]', :delayed
end

file '/etc/logstash/logstash.key' do
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
