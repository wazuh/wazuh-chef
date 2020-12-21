# Cookbook Name:: filebeat
# Recipe:: repository
# Author:: Wazuh <info@wazuh.com>

case node['platform']
when 'ubuntu', 'debian'
  package 'lsb-release'

  ohai 'reload lsb' do
    plugin 'lsb'
    subscribes :reload, 'package[lsb-release]', :immediately
  end

  apt_repository 'wazuh' do
    key 'https://packages.wazuh.com/key/GPG-KEY-WAZUH'
    uri "http://packages.wazuh.com/#{node['wazuh']['major_version']}/apt/"
    components ['main']
    distribution 'stable'
    action :add
  end

  apt_update
when 'redhat', 'centos', 'amazon', 'fedora', 'oracle'
  yum_repository 'wazuh' do
    description 'WAZUH Yum Repository - www.wazuh.com'
    gpgcheck true
    gpgkey 'https://packages.wazuh.com/key/GPG-KEY-WAZUH'
    enabled true 
    baseurl "https://packages.wazuh.com/#{node['wazuh']['major_version']}/yum/"
    action :create
  end
when 'opensuseleap', 'suse'
  zypper_repository 'wazuh' do   
    description 'WAZUH Zypper Repository - www.wazuh.com'
    gpgcheck true
    gpgkey 'https://packages.wazuh.com/key/GPG-KEY-WAZUH'
    enabled true 
    baseurl "https://packages.wazuh.com/#{node['wazuh']['major_version']}/yum/"
    action :create
  end
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end