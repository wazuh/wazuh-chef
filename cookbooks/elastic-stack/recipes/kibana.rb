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

# Set up Kibana port

ruby_block 'Set up Kibana port' do
  block do
    if node['xpack']['enabled']
      node.default['kibana']['yml']['server']['port'] = 443
    else
      node.default['kibana']['yml']['server']['port'] = 5601
    end
  end
  action :run
end

# Copy certs

directory "#{node['kibana']['certs_path']}" do
  owner 'kibana'
  group 'kibana'
  mode '0755'
  action :create
  only_if { node['xpack']['enabled'] }
end

bash "Copy the certificate authorities, the certificate and key" do
  code <<-EOH
  mkdir #{node['kibana']['certs_path']}/ca -p
  cp /tmp/certs/ca/ca.crt #{node['kibana']['certs_path']}/ca 
  cp /tmp/certs/kibana/* #{node['kibana']['certs_path']}
  chown -R kibana: #{node['kibana']['certs_path']}
  chmod -R 500 #{node['kibana']['certs_path']}
  chmod 400 #{node['kibana']['certs_path']}/ca/ca.* #{node['kibana']['certs_path']}/kibana.*
  EOH
  only_if {
    node['xpack']['enabled'] &&
    Dir.empty?("#{node['kibana']['certs_path']}")
  }
end

# Create Kibana configuration file

template "#{node['kibana']['config_path']}/kibana.yml" do
  source 'kibana.yml.erb'
  owner 'kibana'
  group 'kibana'
  mode '0755'
  variables({
    host: node['kibana']['yml']['server']['host'],
    port: node['kibana']['yml']['server']['port'],
    elasticsearch_hosts: node['kibana']['yml']['elasticsearch']['hosts'],
    elasticsearch_password: node['kibana']['yml']['elasticsearch']['password'],
    ssl_enabled: true,
    xpack_enabled: node['xpack']['enabled'],
    xpack_ca: node['xpack']['kibana']['ca'],
    xpack_cert: node['xpack']['kibana']['cert'],
    xpack_key: node['xpack']['kibana']['key']
  })
end

# Create data directory

directory "#{node['kibana']['data_path']}" do
  owner 'kibana'
  group 'kibana'
  mode '0755'
  action :create
end

# Update the kibana directories permissions

execute "Change #{node['kibana']['package_path']} owner" do
  command "sudo chown -R kibana:kibana #{node['kibana']['package_path']}"
end

# Install the Wazuh Kibana plugin

directory "#{node['kibana']['data_path']}/wazuh" do
  owner 'kibana'
  group 'kibana'
  mode '0755'
  action :create
end

directory "#{node['kibana']['data_path']}/wazuh/config" do
  owner 'kibana'
  group 'kibana'
  mode '0755'
  action :create
end

execute 'Install the Wazuh app plugin for Kibana' do
  command "sudo -u kibana #{node['kibana']['package_path']}/bin/kibana-plugin install https://packages.wazuh.com/#{node['wazuh']['major_version']}/ui/kibana/wazuh_kibana-#{node['wazuh']['kibana_plugin_version']}-1.zip"
  not_if {
    Dir.exist?("#{node['kibana']['plugins_path']}/wazuh")
  }
end

# Configure Wazuh-Kibana plugin configuration file

template "#{node['kibana']['data_path']}/wazuh/config/wazuh.yml" do
  source 'wazuh.yml.erb'
  owner 'kibana'
  group 'kibana'
  mode 0755
  action :create
  variables({
    api_credentials: node['kibana']['wazuh_api_credentials']
  })
  only_if {
    Dir.exist?("#{node['kibana']['data_path']}/wazuh/config")
  }
end

# Link Kibana socket to 443 port

execute "Link Kibana socket to 443 port" do
  command "setcap \'cap_net_bind_service=+ep\' #{node['kibana']['package_path']}/node/bin/node"
  only_if { node['xpack']['enabled'] }
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
          (node['elastic']['yml']['host']).to_s,
          node['elastic']['yml']['port']
        )
      rescue StandardError
        nil
      end
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
    end
  end
end

log 'Access Kibana web interface' do
  message "URL: http://#{node['kibana']['yml']['server']['host']}:#{node['kibana']['yml']['server']['port']}
  user: #{node['kibana']['yml']['elasticsearch']['username']}
  password: #{node['kibana']['yml']['elasticsearch']['password']}"
  level :info
end
