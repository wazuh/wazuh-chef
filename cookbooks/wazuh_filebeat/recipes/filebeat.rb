#
# Cookbook Name:: filebeat
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

include_recipe 'wazuh_filebeat::repository'

package 'filebeat' do
    version node['filebeat']['elastic_stack_version']
end

bash 'Elasticsearch_template' do
  code <<-EOH
  curl -so /etc/filebeat/wazuh-template.json "https://raw.githubusercontent.com/wazuh/wazuh/#{node['filebeat']['extensions_version']}/extensions/elasticsearch/7.x/wazuh-template.json"
  EOH
end

template node['filebeat']['config_path'] do
  source 'filebeat.yml.erb'
  owner 'root'
  group 'root'
  mode '0640'
  variables(elasticsearch_server_ip: "  hosts: ['#{node['filebeat']['elasticsearch_server_ip']}:9200']")
end

service node['filebeat']['service_name'] do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end
