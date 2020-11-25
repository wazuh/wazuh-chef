#
# Cookbook Name:: filebeat
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

# Install Filebeat package
require 'yaml'

if platform_family?('debian','ubuntu')
  package 'lsb-release'
  ohai 'reload lsb' do
    plugin 'lsb'
    # action :nothing
    subscribes :reload, 'package[lsb-release]', :immediately
  end
			
  apt_package 'filebeat' do
    version "#{node['filebeat']['version']}" 
    only_if do
      File.exists?("/etc/apt/sources.list.d/wazuh.list")
    end
  end
elsif platform_family?('rhel', 'redhat', 'centos')
  if node['platform_version'] >= '8'
    dnf_package 'filebeat' do
      version "#{node['filebeat']['version']}"
      only_if do
        File.exists?("/etc/yum.repos.d/wazuh.repo")
      end
    end
  else
    yum_package 'filebeat' do
      version "#{node['filebeat']['version']}"
      only_if do
        File.exists?("/etc/yum.repos.d/wazuh.repo")
      end
    end
  end 
elsif platform_family?('suse')
  yum_package 'filebeat' do
    version "#{node['filebeat']['version']}"
    only_if do
      File.exists?("/etc/zypp/repos.d/wazuh.repo")
    end
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
    hosts: node["filebeat"]["elastic_nodes"] 
  )
end

# Download the alerts template for Elasticsearch:

remote_file "/etc/filebeat/#{node['filebeat']['wazuh_template']}" do
  source "https://raw.githubusercontent.com/wazuh/wazuh/#{node['wazuh']['version']}/extensions/elasticsearch/#{node['elastic']['version']}/#{node['filebeat']['wazuh_template']}"
  owner "root"
  group "root"
  mode "0644"
end

# Download the Wazuh module for Filebeat:
remote_file "/usr/share/filebeat/module/#{node['filebeat']['wazuh_filebeat_module']}" do
  source "https://packages.wazuh.com/#{node['packages.wazuh.com']['version']}/filebeat/#{node['filebeat']['wazuh_filebeat_module']}"
end

# Change module permission 
directory '/usr/share/filebeat/module/wazuh' do
  mode '0755'
  recursive true
end
