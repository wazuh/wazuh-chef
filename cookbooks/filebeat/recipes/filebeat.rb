# Cookbook Name:: filebeat
# Recipe:: default
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
    hosts: node['filebeat']['yml']['output']['elasticsearch']['hosts']
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

# Enable and start service

service "filebeat" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [:enable, :start]
end