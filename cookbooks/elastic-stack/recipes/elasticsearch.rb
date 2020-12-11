# frozen_string_literal: true

# Cookbook Name:: elastic-stack
# Recipe:: elasticsearch
# Author:: Wazuh <info@wazuh.com>

# Install the Elasticsearch package

case node['platform']
when 'debian', 'ubuntu'
  apt_package 'elasticsearch' do
    version (node['elk']['patch_version']).to_s
  end
when 'redhat', 'centos', 'amazon', 'fedora', 'oracle'
  if node['platform_version'] >= '8'
    dnf_package 'elasticsearch' do
      version (node['elk']['patch_version']).to_s
    end
  else
    yum_package 'elasticsearch' do
      version (node['elk']['patch_version']).to_s
    end
  end
when 'opensuseleap', 'suse'
  zypper_package 'elasticsearch' do
    version (node['elk']['patch_version']).to_s
  end
else
  raise 'Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added'
end

# Set up elasticsearch config file

template "#{node['elastic']['config_path']}/elasticsearch.yml" do
  source 'elasticsearch.yml.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0660'
  variables({
              cluster_name: node['elastic']['yml']['cluster']['name'],
              node_name: node['elastic']['yml']['node']['name'],
              path_data: node['elastic']['yml']['path']['data'],
              path_logs: node['elastic']['yml']['path']['logs'],
              network_host: node['elastic']['yml']['network']['host'],
              http_port: node['elastic']['yml']['http']['port'],
              initial_master_nodes: node['elastic']['yml']['cluster']['initial_master_nodes']
            })
end

# Set up jvm options

template "#{node['elastic']['config_path']}/jvm.options" do
  source 'jvm.options.erb'
  owner 'root'
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

# Verify Elasticsearch folders owner

directory (node['elastic']['config_path']).to_s do
  owner 'elasticsearch'
  group 'elasticsearch'
  recursive true
end

directory '/usr/share/elasticsearch' do
  owner 'elasticsearch'
  group 'elasticsearch'
  recursive true
end

directory '/var/lib/elasticsearch' do
  owner 'elasticsearch'
  group 'elasticsearch'
  recursive true
end

# Enable and start service

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
