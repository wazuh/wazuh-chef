# Cookbook Name:: filebeat
# Recipe:: filebeat
# Author:: Wazuh <info@wazuh.com>

# Install Filebeat package

case node['platform']
when 'debian','ubuntu'
  apt_package 'filebeat' do
    version "#{node['elk']['patch_version']}" 
  end
when 'redhat', 'centos', 'amazon', 'fedora', 'oracle'
  if node['platform_version'] >= '8' 
    dnf_package 'filebeat' do
      version "#{node['elk']['patch_version']}"
    end
  else  
    yum_package 'filebeat' do
      version "#{node['elk']['patch_version']}"
    end
  end
when 'opensuseleap', 'suse'
  zypper_package 'filebeat' do
    version "#{node['elk']['patch_version']}"
  end
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end

# Edit the file /etc/filebeat/filebeat.yml

template "#{node['filebeat']['config_path']}/filebeat.yml" do
  source 'filebeat.yml.erb'
  owner 'root'
  group 'root'
  mode '0640'
  variables(
    ip: node['filebeat']['yml']['elasticsearch']['ip'],
    port: node['filebeat']['yml']['elasticsearch']['port'],
    password: node['filebeat']['yml']['elasticsearch']['password'],
    xpack_cert: node['xpack']['cert'],
    xpack_key: node['xpack']['key'],
    xpack_ca: node['xpack']['ca']
  )
end

# Download the alerts template for Elasticsearch

remote_file "#{node['filebeat']['config_path']}/#{node['filebeat']['alerts_template']}" do
  source "https://raw.githubusercontent.com/wazuh/wazuh/#{node['wazuh']['minor_version']}/extensions/elasticsearch/#{node['elk']['major_version']}/#{node['filebeat']['alerts_template']}"
  owner 'root'
  group 'root'
  mode '0644'
end

# Download Wazuh module for Filebeat

execute 'Extract Wazuh module' do
  command "curl -s https://packages.wazuh.com/#{node['wazuh']['major_version']}/filebeat/#{node['filebeat']['wazuh_module']} | tar -xvz -C #{node['filebeat']['wazuh_module_path']}"
  action :run
end

# Copy certs

directory "#{node['filebeat']['certs_path']}" do
  action :create
end

bash "Copy the certificate authorities, the certificate and key" do
  code <<-EOH
  mkdir #{node['filebeat']['certs_path']}/ca -p
  cp -R /tmp/certs/ca/ /tmp/certs/filebeat/* #{node['filebeat']['certs_path']}
  chmod -R 500 #{node['filebeat']['certs_path']}
  chmod 400 #{node['filebeat']['certs_path']}/ca/ca.* #{node['filebeat']['certs_path']}/filebeat.*
  EOH
  only_if {
    Dir.empty?("#{node['filebeat']['certs_path']}")
  }
end

# Enable and start service

service "filebeat" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [:enable, :start]
end
