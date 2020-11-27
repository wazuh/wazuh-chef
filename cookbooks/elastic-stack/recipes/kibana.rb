
# Cookbook Name:: elastic-stack
# Recipe:: kibana
# Author:: Wazuh <info@wazuh.com>

# Install the Kibana package

case node['platform']
when 'debian', 'ubuntu'
  apt_package 'kibana' do
    version "#{node['elk']['patch_version']}"
  end
when 'redhat', 'centos', 'amazon', 'fedora', 'oracle'
  if node['platform_version'] >= '8'
    dnf_package 'kibana' do
      version "#{node['elk']['patch_version']}"
    end
  else 
    yum_package 'kibana' do
      version "#{node['elk']['patch_version']}"
    end
  end
when 'opensuseleap', 'suse'
  zypper_package 'kibana' do
    version "#{node['elk']['patch_version']}"
  end
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
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

bash 'Install the Wazuh app plugin for Kibana' do
  code <<-EOH
    cd #{node['kibana']['package_path']}
    sudo -u kibana bin/kibana-plugin install https://packages.wazuh.com/#{node['wazuh']['major_version']}/ui/kibana/wazuh_kibana-#{node['wazuh']['kibana_plugin_version']}-1.zip
  EOH
end

# Set up Kibana configuration file

template "#{node['kibana']['config_path']}/kibana.yml" do
  source 'kibana.yml.erb'
  owner 'root'
  group 'kibana'
  mode 0755
  variables({
    server_port: node['kibana']['yml']['server']['port'],
    server_host: node['kibana']['yml']['server']['host'],
    elasticsearch_hosts: node['kibana']['yml']['elasticsearch']['hosts']
  })
end

bash 'Configure the credentials to access the Wazuh API' do
  code <<-EOH
    cat >> #{node['kibana']['package_path']}/optimize/wazuh/config/wazuh.yml << EOF
    - #{node['kibana']['wazuh_api_credentials']['id']}:
       url: #{node['kibana']['wazuh_api_credentials']['url']}
       port: #{node['kibana']['wazuh_api_credentials']['port']}
       username: #{node['kibana']['wazuh_api_credentials']['username']}
       password: #{node['kibana']['wazuh_api_credentials']['password']}
    EOF
  EOH
end

# Enable and start the Kibana service

service "kibana" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [:restart]
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

bash 'Waiting for elasticsearch curl response...' do
  code <<-EOH
  until (curl -XGET #{node['kibana']['yml']['elasticsearch']['hosts']}); do
    printf 'Waiting for elasticsearch....'
    sleep 5
  done
  EOH
end