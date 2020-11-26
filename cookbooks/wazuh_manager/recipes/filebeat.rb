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


