# Cookbook Name:: opendistro
# Recipe:: kibana
# Author:: Wazuh <info@wazuh.com>

# Install the Kibana package

case node['platform']
when 'debian', 'ubuntu'
  apt_package 'opendistroforelasticsearch-kibana' do
    version "#{node['odfe']['patch_version']}"
  end
when 'redhat', 'centos', 'amazon', 'fedora', 'oracle'
  if node['platform_version'] >= '8'
    dnf_package 'opendistroforelasticsearch-kibana' do
      version "#{node['odfe']['patch_version']}"
    end
  else
    yum_package 'opendistroforelasticsearch-kibana' do
      version "#{node['odfe']['patch_version']}"
    end
  end
when 'opensuseleap', 'suse'
  zypper_package 'opendistroforelasticsearch-kibana' do
    version "#{node['odfe']['patch_version']}"
  end
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end

# Create Kibana configuration file

template "#{node['kibana']['config_path']}/kibana.yml" do
  source 'kibana.yml.erb'
  owner 'root'
  group 'kibana'
  variables({
    server_port: "#{node['kibana']['yml']['server']['port']}",
    server_host: "#{node['kibana']['yml']['server']['host']}",
    elasticsearch_hosts: node['kibana']['yml']['elasticsearch']['hosts']
  })
  mode 0755
end

# Change Kibana folders owner 

directory "#{node['kibana']['optimize_path']}" do
  owner 'kibana'
  group 'kibana'
  recursive true 
end

directory "#{node['kibana']['plugins_path']}" do
  owner 'kibana'
  group 'kibana'
  recursive true 
end

# Install the Wazuh Kibana plugin

execute 'Install Wazuh Kibana plugin' do
  command "sudo -u kibana #{node['kibana']['package_path']}/bin/kibana-plugin install https://packages.wazuh.com/#{node['wazuh']['major_version']}/ui/kibana/wazuh_kibana-#{node['wazuh']['kibana_plugin_version']}-1.zip"
end

# Create Wazuh-Kibana plugin configuration file

directory "#{node['kibana']['optimize_path']}/wazuh" do
  owner 'kibana'
  group 'kibana'
  action :create
end

directory "#{node['kibana']['optimize_path']}/wazuh/config" do
  owner 'kibana'
  group 'kibana'
  action :create
end

directory "#{node['kibana']['optimize_path']}/wazuh/logs" do
  owner 'kibana'
  group 'kibana'
  action :create
end

template "#{node['kibana']['optimize_path']}/wazuh/config/wazuh.yml" do
  source 'wazuh.yml.erb'
  owner 'kibana'
  group 'kibana'
  mode '0600'
  action :create
  variables ({
    id: node['kibana']['wazuh_api_credentials']['id'],
    url: node['kibana']['wazuh_api_credentials']['url'],
    port: node['kibana']['wazuh_api_credentials']['port'],
    username: node['kibana']['wazuh_api_credentials']['username'],
    password: node['kibana']['wazuh_api_credentials']['password']
  })
end

# Certificates placement

directory "#{node['kibana']['certs_path']}" do
  action :create
end

ruby_block 'Copy certificate files' do
  block do
    if File.exist?("#{node['elastic']['certs_path']}")
      IO.copy_stream("#{node['elastic']['certs_path']}/kibana_http.pem", "#{node['kibana']['certs_path']}/kibana.pem")
      IO.copy_stream("#{node['elastic']['certs_path']}/kibana_http.key", "#{node['kibana']['certs_path']}/kibana.key")
      IO.copy_stream("#{node['elastic']['certs_path']}/root-ca.pem", "#{node['kibana']['certs_path']}/root-ca.pem")
    else
      Chef::Log.fatal("Please copy the following files where Elasticsearch is installed to 
        #{node['kibana']['certs_path']}:
          - #{node['elastic']['certs_path']}/kibana_http.key (rename as kibana.key) 
          - #{node['elastic']['certs_path']}/kibana_http.pem (rename as kibana.pem)
          - #{node['elastic']['certs_path']}/root-ca.pem
        Then run as sudo:
          - systemctl daemon-reload
          - systemctl enable kibana
          - systemctl start kibana")
    end
  end
  action :run
end

# Link Kibana’s socket to privileged port 443

execute 'Link kibana socket to 443 port' do
  command "setcap 'cap_net_bind_service=+ep' #{node['kibana']['package_path']}/node/bin/node"
end

# Enable and start the Kibana service

service "kibana" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [:enable, :start]
  only_if {
    File.exist?("#{node['kibana']['certs_path']}/kibana.pem") &&
    File.exist?("#{node['kibana']['certs_path']}/kibana.key") &&
    File.exist?("#{node['kibana']['certs_path']}/root-ca.pem")
  }
end

ruby_block 'Wait for elasticsearch' do
  block do
    loop { break if (TCPSocket.open(
      "#{node['elastic']['yml']['network']['host']}",
      node['elastic']['yml']['http']['port']) rescue nil); 
      puts "Waiting elasticsearch...."; sleep 1 
    }
  end
end

ruby_block 'Wait for kibana' do
  block do
    loop { break if (TCPSocket.open(
      "#{node['kibana']['yml']['server']['host']}",
      node['kibana']['yml']['server']['port']) rescue nil); 
      puts "Waiting kibana...."; sleep 60
    }
  end
end

bash 'Waiting for kibana curl response...' do
  code <<-EOH
  until (curl -XGET https://#{node['kibana']['yml']['server']['host']}:#{node['kibana']['yml']['server']['port']} -u admin:admin -k); do
    printf 'Waiting for kibana....'
    sleep 5
  done
  EOH
end

log 'Access Kibana web interface' do
  message "URL: https://#{node['kibana']['yml']['server']['host']}
  user: admin
  password: admin"
  level :info
end