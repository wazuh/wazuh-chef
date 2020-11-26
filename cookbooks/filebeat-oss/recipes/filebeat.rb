# Cookbook Name:: filebeat
# Recipe:: filebeat-oss
# Author:: Wazuh <info@pwazuh.com>

# Install filebeat-oss pacakge

if platform_family?('debian','ubuntu')
    package 'lsb-release'
    ohai 'reload lsb' do
      plugin 'lsb'
      subscribes :reload, 'package[lsb-release]', :immediately
    end
              
    apt_package 'filebeat' do
      version "#{node['elk']['patch_version']}" 
    end
  elsif platform_family?('redhat', 'centos', 'amazon', 'fedora', 'oracle')
    if node['platform']['version'] >= '8' 
      dnf_package 'filebeat' do
        version "#{node['elk']['patch_version']}"
      end
    else  
      yum_package 'filebeat' do
        version "#{node['elk']['patch_version']}"
      end
    end
  elsif platform_family?('opensuse', 'suse')
    yum_package 'filebeat' do
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
    hosts: node['filebeat']['elasticsearch_server_ip']
  )
end

# Download the alerts template for Elasticsearch

remote_file "#{node['filebeat']['config_path']}/#{node['filebeat']['alerts_template']}" do
  source "https://raw.githubusercontent.com/wazuh/wazuh/v#{node['wazuh']['minor_version']}/extensions/elasticsearch/#{node['elk']['major_version']}/#{node['filebeat']['alerts_template']}"
  owner 'root'
  group 'root'
  mode '0644'
end

# Download the Wazuh module for Filebeat

remote_file "#{node['filebeat']['config_path']}/#{node['filebeat']['wazuh_module']}" do
  source "https://packages.wazuh.com/#{node['wazuh']['minor_version']}/filebeat/#{node['filebeat']['wazuh_module']}"
end

archive_file "#{node['filebeat']['wazuh_module']}" do
  path "#{node['filebeat']['config_path']}/#{node['filebeat']['wazuh_module']}"
  destination "#{node['filebeat']['wazuh_module_path']}"
end

file "#{node['filebeat']['config_path']}/#{node['filebeat']['wazuh_module']}" do
  action :delete
end

# Configure Filebeat certificates

directory "#{node['filebeat']['config_path']}/certs" do
    action :create 
end

log 'filebeat-certificates' do
    message: "Please move the following files on elasticsearch node to
        #{node['filebeat']['config_path']}/certs: 
            - filebeat.pem 
            - filebeat.key 
            - root-ca.pem. 
        Once uploaded, run the following commands as sudo: 
            - systemctl daemon-reload
            - systemctl enable filebeat
            - systemctl start filebeat"
    level :warn
end