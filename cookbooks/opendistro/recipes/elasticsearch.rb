# Cookbook Name:: opendistro
# Recipe:: elasticsearch
# Author:: Wazuh <info@wazuh.com>

# Install opendistroforelasticsearch

if platform_family?('debian', 'ubuntu')
  apt_package 'elasticsearch-oss' do
    version  "#{node['elk']['patch_version']}-1"
  end

  apt_package 'opendistroforelasticsearch' do
    version "#{node['odfe']['patch_version']}-1"
  end

elsif platform_family?('redhat', 'centos', 'amazon', 'fedora', 'oracle')
  if node['platform_version'] >= '8'
    dnf_package 'opendistroforelasticsearch' do
      version "#{node['odfe']['patch_version']}-1"
    end
  else
    yum_package 'opendistroforelasticsearch' do
      version "#{node['odfe']['patch_version']}-1"
    end
  end

elsif platform_family?('opensuse', 'suse')
  zypper_package 'opendistroforelasticsearch' do
    version "#{node['odfe']['patch_version']}-1"
  end

else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end

# Set up opendistro for elasticsearch configuration file

template "#{node['elastic']['config_path']}/elasticsearch.yml" do
  source 'od_elasticsearch.yml.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0660'
  variables (content: Psych.dump(node['odfe']['yml']))
end

# Add extra roles and users to Wazuh Kibana plugin

remote_file "#{node['elastic']['plugins_path']}/opendistro_security/securityconfig/roles.yml" do
  source "https://raw.githubusercontent.com/wazuh/wazuh-documentation/#{node['wazuh']['minor_version']}/resources/open-distro/elasticsearch/roles/roles.yml"
end

remote_file "#{node['elastic']['plugins_path']}/opendistro_security/securityconfig/roles_mapping.yml" do
  source "https://raw.githubusercontent.com/wazuh/wazuh-documentation/#{node['wazuh']['minor_version']}/resources/open-distro/elasticsearch/roles/roles_mapping.yml"
end

remote_file "#{node['elastic']['plugins_path']}/opendistro_security/securityconfig/internal_users.yml" do
  source "https://raw.githubusercontent.com/wazuh/wazuh-documentation/#{node['wazuh']['minor_version']}/resources/open-distro/elasticsearch/roles/internal_users.yml"
end

# Certificates creation and deployment

## Remove the demo certificates

file "#{node['elastic']['config_path']}/esnode-key.pem" do
  action :delete
end

file "#{node['elastic']['config_path']}/esnode.pem" do
  action :delete
end

file "#{node['elastic']['config_path']}/kirk-key.pem" do
  action :delete
end

file "#{node['elastic']['config_path']}/kirk.pem" do
  action :delete
end

file "#{node['elastic']['config_path']}/root-ca.pem" do
  action :delete
end

## Generate and deploy the certificates

directory "#{node['elastic']['config_path']}/certs" do
  action :create
end

directory "#{node['searchguard']['config_path']}" do
  action :create
end

remote_file "#{node['searchguard']['config_path']}/#{node['searchguard']['tls_tool']}" do
  source "https://maven.search-guard.com/search-guard-tlstool/#{node['search_guard']['version']}/#{node['search_guard']['tls_tool']}"
end

archive_file "#{node['searchguard']['tls_tool']}" do
  path "#{node['searchguard']['config_path']}/#{node['searchguard']['tls_tool']}"
  destination "#{node['search_guard']['config_path']}"
end

template "#{node['search_guard']['config_path']}/search-guard.yml" do
  source 'search-guard.yml.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0660'
  variables ({
    elastic_node_ip: node['elastic']['yml']['network']['host'],
    kibana_node_ip: node['kibana']['yml']['server']['host']

end

execute 'Run the Search Guard’s script to create the certificates' do
  command "#{node['searchguard']['config_path']}/tools/sgtlstool.sh -c #{node['searchguard']['config_path']}/search-guard.yml -ca -crt -t #{node['elastic']['config_path']}/certs/"
end

bash 'Compress all the necessary files to be sent to the all the instances' do
  code <<-EOF
    cd #{node['elastic']['config_path']}/certs 
    tar -cf certs.tar *
  EOF
end

log 'Copy certs.tar to all the servers of the distributed deployment' do
  message: "Please copy #{node['elastic']['config_path']}/certs/certs.tar to all filebeat nodes"
  level :warn
end

## Remove unnecessary files

file "#{node['elastic']['config_path']}/certs/client-certificates.readme" do
  action :delete
end

file "#{node['elastic']['config_path']}/certs/elasticsearch_elasticsearch_config_snippet.yml" do
  action :delete
end

file "#{node['searchguard']['config_path']}/#{node['searchguard']['tls_tool']}" do
  action :delete
end

# Verify Elasticsearch folders owner 

directory "#{'elastic']['config_path']}" do
  owner 'elasticsearch'
  group 'elasticsearch'
  recursive true
end

directory "/usr/share/elasticsearch" do
  owner 'elasticsearch'
  group 'elasticsearch'
  recursive true
end

directory "/var/lib/elasticsearch" do
  owner 'elasticsearch'
  group 'elasticsearch'
  recursive true
end

# Run elasticsearch service

service "elasticsearch" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [:enable, :start]
end

ruby_block 'wait for elasticsearch' do
  block do
    loop { break if (TCPSocket.open(
      "#{node['elastic']['yml']['network']['host']}",
      node['elastic']['yml']['http']['port']) rescue nil
    ); puts "Waiting for elasticsearch to start"; sleep 5 }
  end
end

execute 'Run the Elasticsearch’s securityadmin script' do
  command  "#{node['elastic']['plugins_path']}/opendistro_security/tools/securityadmin.sh -cd #{node['elastic']['plugins_path']}/opendistro_security/securityconfig/ -nhnv -cacert #{node['elastic']['config_path']}/certs/root-ca.pem -cert #{node['elastic']['config_path']}/certs/admin.pem -key #{node['elastic']['config_path']}/certs/admin.key -h #{node['elastic']['elasticsearch_ip']}"
end


