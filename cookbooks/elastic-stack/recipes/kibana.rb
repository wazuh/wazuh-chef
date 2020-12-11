# frozen_string_literal: true

# Cookbook Name:: elastic-stack
# Recipe:: kibana
# Author:: Wazuh <info@wazuh.com>

# Install the Kibana package

case node['platform']
when 'debian', 'ubuntu'
  apt_package 'kibana' do
    version (node['elk']['patch_version']).to_s
  end
when 'redhat', 'centos', 'amazon', 'fedora', 'oracle'
  if node['platform_version'] >= '8'
    dnf_package 'kibana' do
      version (node['elk']['patch_version']).to_s
    end
  else
    yum_package 'kibana' do
      version (node['elk']['patch_version']).to_s
    end
  end
when 'opensuseleap', 'suse'
  zypper_package 'kibana' do
    version (node['elk']['patch_version']).to_s
  end
else
  raise 'Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added'
end

# Create Kibana configuration file

template "#{node['kibana']['config_path']}/kibana.yml" do
  source 'kibana.yml.erb'
  owner 'kibana'
  group 'kibana'
  mode 0o755
  variables({
              server_port: node['kibana']['yml']['server']['port'],
              server_host: node['kibana']['yml']['server']['host'],
              elasticsearch_hosts: node['kibana']['yml']['elasticsearch']['hosts']
            })
end

# Update the optimize and plugins directories permissions

directory "#{node['kibana']['package_path']}/optimize" do
  owner 'kibana'
  group 'kibana'
  recursive true
end

directory "#{node['kibana']['package_path']}/plugins" do
  owner 'kibana'
  group 'kibana'
  recursive true
end

# Install the Wazuh Kibana plugin

execute 'Install the Wazuh app plugin for Kibana' do
  command "sudo -u kibana #{node['kibana']['package_path']}/bin/kibana-plugin install https://packages.wazuh.com/#{node['wazuh']['major_version']}/ui/kibana/wazuh_kibana-#{node['wazuh']['kibana_plugin_version']}-1.zip"
  not_if do
    File.exist?("#{node['kibana']['package_path']}/optimize/wazuh/config/wazuh.yml")
  end
end

# Configure Wazuh-Kibana plugin configuration file

template "#{node['kibana']['package_path']}/optimize/wazuh/config/wazuh.yml" do
  source 'wazuh.yml.erb'
  owner 'kibana'
  group 'kibana'
  mode 0o755
  action :create
  variables({
              api_credentials: node['kibana']['wazuh_api_credentials']
            })
  only_if do
    File.exist?("#{node['kibana']['package_path']}/optimize/wazuh/config/wazuh.yml")
  end
end

# Enable and start the Kibana service

service 'kibana' do
  supports start: true, stop: true, restart: true, reload: true
  action %i[enable start]
end

# Wait for elastic and kibana services

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

      puts 'Waiting elasticsearch....'; sleep 1
    end
  end
end

ruby_block 'Wait for kibana' do
  block do
    loop do
      break if begin
        TCPSocket.open(
          (node['kibana']['yml']['server']['host']).to_s,
          node['kibana']['yml']['server']['port']
        )
      rescue StandardError
        nil
      end

      puts 'Waiting kibana....'; sleep 60
    end
  end
end

bash 'Waiting for kibana curl response...' do
  code <<-EOH
  until (curl -XGET http://#{node['kibana']['yml']['server']['host']}:#{node['kibana']['yml']['server']['port']}); do
    printf 'Waiting for kibana....'
    sleep 5
  done
  EOH
end

log 'Access Kibana web interface' do
  message "URL: http://#{node['kibana']['yml']['server']['host']}:#{node['kibana']['yml']['server']['port']}
  user: admin
  password: admin"
  level :info
end
