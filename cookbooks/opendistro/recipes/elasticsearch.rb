# frozen_string_literal: true

## Cookbook Name:: opendistro
## Recipe:: elasticsearch
## Author:: Wazuh <info@wazuh.com>

# Install opendistroforelasticsearch

case node['platform']
when 'debian', 'ubuntu'
  apt_package 'elasticsearch-oss' do
    version (node['elk']['patch_version']).to_s
  end
  apt_package 'opendistroforelasticsearch' do
    version "#{node['odfe']['patch_version']}-1"
  end
when 'redhat', 'centos', 'amazon', 'fedora', 'oracle'
  if node['platform_version'] >= '8'
    dnf_package 'elasticsearch-oss' do
      version (node['elk']['patch_version']).to_s
    end
    dnf_package 'opendistroforelasticsearch' do
      version "#{node['odfe']['patch_version']}-1"
    end
  else
    yum_package 'elasticsearch-oss' do
      version (node['elk']['patch_version']).to_s
    end
    yum_package 'opendistroforelasticsearch' do
      version "#{node['odfe']['patch_version']}-1"
    end
  end
when 'opensuseleap', 'suse'
  zypper_package 'elasticsearch-oss' do
    version (node['elk']['patch_version']).to_s
  end
  zypper_package 'opendistroforelasticsearch' do
    version (node['odfe']['patch_version']).to_s
  end
else
  raise 'Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added'
end

# Set up opendistro for elasticsearch configuration file

template "#{node['elastic']['config_path']}/elasticsearch.yml" do
  source 'elasticsearch.yml.erb'
  owner 'elasticsearch'
  group 'elasticsearch'
  mode '0660'
  variables({
    network_host: node['elastic']['yml']['network']['host'],
    http_port: node['elastic']['yml']['http']['port'],
    node_name: node['elastic']['yml']['node']['name'],
    initial_master_nodes: node['elastic']['yml']['cluster']['initial_master_nodes']
  })
end

# Set up jvm options

template "#{node['elastic']['config_path']}/jvm.options" do
  source 'jvm.options.erb'
  owner 'elasticsearch'
  group 'elasticsearch'
  mode '0660'
  variables({ memmory: node['jvm']['memory'] })
end

bash 'insert_line_limits.conf' do
  code <<-EOH
  echo "elasticsearch - nofile  65535" >> /etc/security/limits.conf
  echo "elasticsearch - memlock unlimited" >> /etc/security/limits.conf
  EOH
  not_if 'grep -q elasticsearch /etc/security/limits.conf'
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

directory (node['elastic']['certs_path']).to_s do
  action :create
end

directory (node['searchguard']['config_path']).to_s do
  action :create
end

remote_file "/tmp/#{node['searchguard']['tls_tool']}" do
  source "https://maven.search-guard.com/search-guard-tlstool/#{node['searchguard']['version']}/#{node['searchguard']['tls_tool']}"
end

execute "Unzip #{node['searchguard']['tls_tool']} on #{node['searchguard']['config_path']}" do
  command "unzip -u /tmp/#{node['searchguard']['tls_tool']} -d #{node['searchguard']['config_path']}"
end

template "#{node['searchguard']['config_path']}/search-guard.yml" do
  source 'search-guard.yml.erb'
  owner 'elasticsearch'
  group 'elasticsearch'
  mode '0660'
  variables({
    elastic_node_ip: node['search_guard']['yml']['nodes']['elasticsearch']['ip'],
    kibana_node_ip: node['search_guard']['yml']['nodes']['kibana']['ip']
  })
end

execute 'Run the Search Guard’s script to create the certificates' do
  command "#{node['searchguard']['config_path']}/tools/sgtlstool.sh -c #{node['searchguard']['config_path']}/search-guard.yml -ca -crt -t #{node['elastic']['certs_path']}/"
  not_if {
    File.exist?("#{node['elastic']['certs_path']}/root-ca.key")
  }
end

bash 'Compress all the necessary files to be sent to the all the instances' do
  code <<-EOF
    cd #{node['elastic']['certs_path']}#{' '}
    tar -cf certs.tar *
  EOF
end

# Copy certs to filebeat and kibana nodes

# Filebeat
ruby_block 'Copy filebeat certificates' do
  block do
    if File.exist?((node['filebeat']['certs_path']).to_s)
      IO.copy_stream("#{node['elastic']['certs_path']}/filebeat.pem", "#{node['filebeat']['certs_path']}/filebeat.pem")
      IO.copy_stream("#{node['elastic']['certs_path']}/filebeat.key", "#{node['filebeat']['certs_path']}/filebeat.key")
      IO.copy_stream("#{node['elastic']['certs_path']}/root-ca.pem", "#{node['filebeat']['certs_path']}/root-ca.pem")
    else
      Chef::Log.fatal("Please copy the following files to #{node['filebeat']['certs_path']} on
      filebeat node. Then run on that node as sudo:
        - systemctl daemon-reload
        - systemctl enable filebeat
        - systemctl start filebeat")
    end
  end
  action :run
end

# Kibana
ruby_block 'Copy kibana certificates' do
  block do
    if File.exist?((node['kibana']['certs_path']).to_s)
      IO.copy_stream("#{node['elastic']['certs_path']}/kibana_http.key", "#{node['kibana']['certs_path']}/kibana.key")
      IO.copy_stream("#{node['elastic']['certs_path']}/kibana_http.pem", "#{node['kibana']['certs_path']}/kibana.pem")
      IO.copy_stream("#{node['elastic']['certs_path']}/root-ca.pem", "#{node['kibana']['certs_path']}/root-ca.pem")
    else
      Chef::Log.fatal("Please copy the following files to #{node['kibana']['certs_path']} where
      Kibana is installed:
        - #{node['elastic']['certs_path']}/kibana_http.key (rename as kibana.key)
        - #{node['elastic']['certs_path']}/kibana_http.pem (rename as kibana.pem)
        - #{node['elastic']['certs_path']}/root-ca.pem
      Then run on Kibana node as sudo:
        - systemctl daemon-reload
        - systemctl enable kibana
        - systemctl start kibana
      Forget this warning in case Kibana will be installed on the same node as Elasticsearch")
    end
  end
  action :run
end

## Remove unnecessary files

file "#{node['elastic']['certs_path']}/client-certificates.readme" do
  action :delete
end

file "#{node['elastic']['certs_path']}/elasticsearch_elasticsearch_config_snippet.yml" do
  action :delete
end

file "/tmp/#{node['searchguard']['tls_tool']}" do
  action :delete
end

# Verify Elasticsearch folders owner

directory (node['elastic']['config_path']).to_s do
  owner 'elasticsearch'
  group 'elasticsearch'
  recursive true
end

directory (node['elastic']['package_path']).to_s do
  owner 'elasticsearch'
  group 'elasticsearch'
  recursive true
end

# Run elasticsearch service

service 'elasticsearch' do
  supports start: true, stop: true, restart: true, reload: true
  action %i[enable start]
end

ruby_block 'Wait for elasticsearch' do
  block do
    loop do
      break if begin
        TCPSocket.open(
          (node['elastic']['yml']['network']['host']).to_s,
          node['elastic']['yml']['http']['port']
        )
      rescue StandardError
        nil
      end

      puts 'Waiting for elasticsearch to start'; sleep 5
    end
  end
end

execute 'Run the Elasticsearch’s securityadmin script' do
  command "#{node['elastic']['plugins_path']}/opendistro_security/tools/securityadmin.sh \
          -cd #{node['elastic']['plugins_path']}/opendistro_security/securityconfig/ \
          -nhnv \
          -cacert #{node['elastic']['certs_path']}/root-ca.pem \
          -cert #{node['elastic']['certs_path']}/admin.pem \
          -key #{node['elastic']['certs_path']}/admin.key \
          -h #{node['elastic']['yml']['network']['host']}"
end

ruby_block 'Wait for elasticsearch' do
  block do
    loop do
      break if begin
        TCPSocket.open(
          (node['elastic']['yml']['network']['host']).to_s,
          node['elastic']['yml']['http']['port']
        )
      rescue StandardError
        nil
      end

      puts 'Waiting for elasticsearch to start'; sleep 5
    end
  end
end
