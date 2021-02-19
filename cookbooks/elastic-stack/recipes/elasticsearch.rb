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

# Set up elasticsearch config file

template "#{node['elastic']['config_path']}/elasticsearch.yml" do
  source 'elasticsearch.yml.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0660'
  variables({
    host: node['elastic']['yml']['host'],
    port: node['elastic']['yml']['port'],
    node_name: node['elastic']['yml']['node_name'],
    cluster_name: node['elastic']['yml']['cluster']['name'],
    initial_master_nodes: node['elastic']['yml']['cluster']['initial_master_nodes'],
    xpack_enabled: node['xpack']['enabled'],
    xpack_ver_mode: node['xpack']['verification_mode'],
    path_data: node['elastic']['yml']['path']['data'],
    path_logs: node['elastic']['yml']['path']['logs'],
    xpack_cert: node['xpack']['elasticsearch']['cert'],
    xpack_ca: node['xpack']['elasticsearch']['ca'],
    xpack_key: node['xpack']['elasticsearch']['key'],
  })
end

# Set up instance config file

template "#{node['elastic']['package_path']}/instances.yml" do
  source 'instances.yml.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0660'
  variables({
    elasticsearch_ip: node['instance']['yml']['elasticsearch_ip'],
    filebeat_ip: node['instance']['yml']['filebeat_ip'],
    kibana_ip: node['instance']['yml']['kibana_ip'],
  })
end

execute "Create the certificates using the elasticsearch-certutil tool" do
  command "#{node['elastic']['package_path']}/bin/elasticsearch-certutil cert ca \
  --pem --in #{node['elastic']['package_path']}/instances.yml --keep-ca-key --out /tmp/certs.zip"
  not_if{
    File.exist?('/tmp/certs.zip')
  }
end

# Copy certs

directory "#{node['elastic']['certs_path']}" do
  owner 'elasticsearch'
  group 'elasticsearch'
  mode '0755'
  action :create
end

bash "Copy the certificate authorities, the certificate and key" do
  code <<-EOH
  unzip /tmp/certs.zip -d /tmp/certs
  mkdir #{node['elastic']['certs_path']}/ca -p
  cp -R /tmp/certs/ca/ /tmp/certs/elasticsearch/* #{node['elastic']['certs_path']}
  chown -R elasticsearch: #{node['elastic']['certs_path']}
  chmod -R 500 #{node['elastic']['certs_path']}
  chmod 400 #{node['elastic']['certs_path']}/ca/ca.* #{node['elastic']['certs_path']}/elasticsearch.*
  EOH
  only_if {
    Dir.empty?("#{node['elastic']['certs_path']}")
  }
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
          (node['elastic']['yml']['host']).to_s,
          node['elastic']['yml']['port']
        )
      rescue StandardError
        nil
      end

      puts 'Waiting for elasticsearch to start'; sleep 5
    end
  end
end

# Generate credentials for all the Elastic Stack pre-built roles and users

log 'Set elastic password' do
  message "Run #{node['elastic']['package_path']}/bin/elasticsearch-setup-passwords to set elastic password"
  level :info
end
