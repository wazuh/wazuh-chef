
# Cookbook Name:: wazuh-elastic
# Recipe:: kibana_install

# Create user and group
#

# Install the Kibana package

if platform_family?('debian', 'ubuntu')
  apt_package 'opendistroforelasticsearch-kibana'
elsif platform_family?('rhel', 'redhat', 'centos', 'amazon')
  yum_package 'opendistroforelasticsearch-kibana'
elsif platform_family?('suse')
  zypper_package 'opendistroforelasticsearch-kibana'
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end

# Download the Kibana configuration file

template '/etc/kibana/kibana.yml' do
  source 'od_kibana.yml.erb'
  owner 'root'
  group 'kibana'
  variables({
    kibana_server_port: "server.port: #{node['wazuh-elastic']['kibana_server_port']}",
    kibana_server_host: "server.host: #{node['wazuh-elastic']['kibana_server_host']}",
    kibana_elasticsearch_server_hosts: "elasticsearch.hosts: ['#{node['wazuh-elastic']['kibana_elasticsearch_server_hosts']}']"
  })
  mode 0755
end

# Update the optimize and plugins directories permissions

bash 'Update the optimize and plugins directories permissions' do
  code <<-EOH
    chown -R kibana:kibana /usr/share/kibana/optimize
    chown -R kibana:kibana /usr/share/kibana/plugins
  EOH
end

# Install the Wazuh Kibana plugin

bash 'Install the Wazuh Kibana plugin' do
  code <<-EOH
    cd /usr/share/kibana
    sudo -u kibana bin/kibana-plugin install https://packages.wazuh.com/4.x/ui/kibana/#{node['wazuh-elastic']['wazuh_app_version']}-1.zip
  EOH
end

# Certificates placement

directory '/etc/kibana/certs' do
  action :create
end

bash 'Copy kibana key and pem files and root-ca pem file' do
  code <<-EOH
    cp /etc/elasticsearch/certs/certs.tar /etc/kibana/certs/
    cd /etc/kibana/certs/
    tar --extract --file=certs.tar kibana_http.pem kibana_http.key root-ca.pem
    mv /etc/kibana/certs/kibana_http.key /etc/kibana/certs/kibana.key
    mv /etc/kibana/certs/kibana_http.pem /etc/kibana/certs/kibana.pem
    rm -f certs.tar
  EOH
end

# Link Kibana’s socket to privileged port 443

execute 'Link kibana socket to 443 port' do
  command "setcap 'cap_net_bind_service=+ep' /usr/share/kibana/node/bin/node"
end

# Enable and start the Kibana service

service "kibana" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [:restart]
end

ruby_block 'Wait for elasticsearch' do
  block do
    loop { break if (TCPSocket.open("#{node['wazuh-elastic']['elasticsearch_ip']}",node['wazuh-elastic']['elasticsearch_port']) rescue nil); puts "Waiting elasticsearch...."; sleep 1 }
  end
end

bash 'Waiting for elasticsearch curl response...' do
  code <<-EOH
  until (curl -XGET http://#{node['wazuh-elastic']['elasticsearch_ip']}:#{node['wazuh-elastic']['elasticsearch_port']}); do
    printf 'Waiting for elasticsearch....'
    sleep 5
  done
  EOH
end