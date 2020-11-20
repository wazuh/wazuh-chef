# -*- encoding: utf-8 -*-
#
# Cookbook Name:: wazuh-elastic
# Recipe:: elasticsearch_install
#
######################################################

# Install opendistroforelasticsearch

if platform_family?('debian', 'ubuntu')
  apt_package 'elasticsearch-oss' do
    version  "#{node['wazuh-elastic']['elastic_stack_version']}-1"
  end
  apt_package 'opendistroforelasticsearch' do
    version "#{node['wazuh-elastic']['odfe_version']}-1"
  end
elsif platform_family?('rhel', 'redhat', 'centos')
  if node['platform_version'] >= '8'
    dnf_package 'elasticsearch-oss' do
      version  "#{node['wazuh-elastic']['elastic_stack_version']}-1"
    end
    dnf_package 'opendistroforelasticsearch' do
      version "#{node['wazuh-elastic']['odfe_version']}-1"
    end
  else
    yum_package 'elasticsearch-oss' do
      version  "#{node['wazuh-elastic']['elastic_stack_version']}-1"
    end
    yum_package 'opendistroforelasticsearch' do
      version "#{node['wazuh-elastic']['odfe_version']}-1"
    end
elsif platform_family?('suse')
  zypper_package 'elasticsearch-oss' do
    version  "#{node['wazuh-elastic']['elastic_stack_version']}-1"
  end
  zypper_package 'opendistroforelasticsearch' do
    version "#{node['wazuh-elastic']['odfe_version']}-1"
  end
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end

# Set up opendistro for elasticsearch configuration file
template "#{node['wazuh-elastic']['config_path']}/elasticsearch.yml" do
  source 'od_elasticsearch.yml.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0660'
  variables (content: Psych.dump(node['odfe']['yml']))
end

remote_file "#{node['wazuh-elastic']['plugins_path']}/opendistro_security/securityconfig/roles.yml" do
  source "https://raw.githubusercontent.com/wazuh/wazuh-documentation/#{node['wazuh']['version']}/resources/open-distro/elasticsearch/roles/roles.yml"
end

remote_file "#{node['wazuh-elastic']['plugins_path']}/opendistro_security/securityconfig/roles_mapping.yml" do
  source "https://raw.githubusercontent.com/wazuh/wazuh-documentation/#{node['wazuh']['version']}/resources/open-distro/elasticsearch/roles/roles_mapping.yml"
end

remote_file "#{node['wazuh-elastic']['plugins_path']}/opendistro_security/securityconfig/internal_users.yml" do
  source "https://raw.githubusercontent.com/wazuh/wazuh-documentation/#{node['wazuh']['version']}/resources/open-distro/elasticsearch/roles/internal_users.yml"
end

# Certificates creation and deployment

execute 'Remove the demo certificates' do
  command "rm #{node['wazuh-elastic']['config_path']}/esnode-key.pem #{node['wazuh-elastic']['config_path']}/esnode.pem #{node['wazuh-elastic']['config_path']}/kirk-key.pem #{node['wazuh-elastic']['config_path']}/kirk.pem #{node['wazuh-elastic']['config_path']}/root-ca.pem -f"
end

directory "#{node['wazuh-elastic']['config_path']}/certs" do
  action :create
end

directory "#{node['search_guard']['config_path']}" do
  action :create
end

remote_file "/tmp/#{node['search_guard']['tls_tool']}" do
  source "https://maven.search-guard.com/search-guard-tlstool/#{node['search_guard']['version']}/#{node['odfe']['search_guard_tls_tool']}"
end

archive_file "#{node['search_guard']['tls_tool']}" do
  path "/tmp/#{node['odfe']['search_guard_tls_tool']}"
  destination "#{node['search_guard']['config_path']}"
end

template "#{node['search_guard']['config_path']}/search-guard.yml" do
  source 'search-guard.yml.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0660'
  variables (content: Psych.dump(node['search_guard']['yml'])) 
end

execute 'Run the Search Guard’s script to create the certificates' do
  command "#{node['search_guard']['config_path']}/tools/sgtlstool.sh -c #{node['search_guard']['config_path']}/search-guard.yml -ca -crt -t #{node['wazuh-elastic']['config_path']}/certs/"
end

bash 'Compress all the necessary files to be sent to the all the instances' do
  code <<-EOF
    cd #{node['wazuh-elastic']['config_path']}/certs 
    tar -cf certs.tar *
  EOF
end

execute 'Remove unnecessary files' do
  command "rm #{node['wazuh-elastic']['config_path']}/certs/client-certificates.readme #{node['wazuh-elastic']['config_path']}/certs/elasticsearch_elasticsearch_config_snippet.yml /tmp/#{node['search_guard']['tls_tool']} -f"
end

# Configure Filebeat certificates

bash 'Configure Filebeat certificates' do
  code <<-EOH
    mkdir /etc/filebeat/certs
    cp #{node['wazuh-elastic']['config_path']}/certs/certs.tar /etc/filebeat/certs/
    cd /etc/filebeat/certs/
    tar --extract --file=certs.tar filebeat.pem filebeat.key root-ca.pem
    rm certs.tar
  EOH
end

# Run filebeat service

service "filebeat" do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end

# Run elasticsearch service

service "elasticsearch" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [:enable, :start]
end

ruby_block 'wait for elasticsearch' do
  block do
    loop { break if (TCPSocket.open("#{node['wazuh-elastic']['elasticsearch_ip']}",node['wazuh-elastic']['elasticsearch_port']) rescue nil); puts "Waiting for elasticsearch to start"; sleep 5 }
  end
end

bash 'Verify Elasticsearch folders owner' do
  code <<-EOF
    chown elasticsearch:elasticsearch -R #{node['wazuh-elastic']['config_path']}
    chown elasticsearch:elasticsearch -R /usr/share/elasticsearch
    chown elasticsearch:elasticsearch -R /var/lib/elasticsearch
  EOF
  notifies :restart, "service[elasticsearch]", :delayed
end

execute 'Run the Elasticsearch’s securityadmin script' do
  command  "#{node['wazuh-elastic']['plugins_path']}/opendistro_security/tools/securityadmin.sh -cd #{node['wazuh-elastic']['plugins_path']}/opendistro_security/securityconfig/ -nhnv -cacert #{node['wazuh-elastic']['config_path']}/certs/root-ca.pem -cert #{node['wazuh-elastic']['config_path']}/certs/admin.pem -key #{node['wazuh-elastic']['config_path']}/certs/admin.key -h #{node['wazuh-elastic']['elasticsearch_ip']}"
end


