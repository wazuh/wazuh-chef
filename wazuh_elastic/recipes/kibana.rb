#
# Cookbook Name:: wazuh-elastic
# Recipe:: kibana_install

# Create user and group
#

package 'kibana' do
  version node['wazuh-elastic']['elastic_stack_version']
end

template 'kibana.yml' do
  path '/etc/kibana/kibana.yml'
  source 'kibana.yml.erb'
  owner 'root'
  group 'root'
  variables({
     :kibana_port => node['wazuh-elastic']['kibana_port'],
     :kibana_host => node['wazuh-elastic']['kibana_host'],
     :kibana_elasticsearch_server => node['wazuh-elastic']['kibana_elasticsearch_server']
  })
  mode 0755
end

ruby_block 'wait for elasticsearch' do
  block do
    loop { break if (TCPSocket.open("#{node['wazuh-elastic']['elasticsearch_ip']}",node['wazuh-elastic']['elasticsearch_port']) rescue nil); puts "Waiting elasticsearch...."; sleep 1 }
  end
end

bash 'Install Wazuh-APP (can take a while)' do
  code <<-EOH
  export NODE_OPTIONS="--max-old-space-size=3072"
  /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/wazuhapp/wazuhapp-3.2.4_6.2.4.zip
  EOH
  creates '/usr/share/kibana/plugins/wazuh/package.json'
  notifies :restart, 'service[kibana]', :delayed
end

service 'kibana' do
  supports status: true, restart: false
  action [:enable, :start]
end
