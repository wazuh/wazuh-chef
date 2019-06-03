#
# Cookbook Name:: wazuh-elastic
# Recipe:: kibana_install

# Create user and group
#

if platform_family?('debian', 'ubuntu')
  apt_package 'kibana' do
    version "#{node['wazuh-elastic']['elastic_stack_version']}"
  end
elsif platform_family?('rhel', 'redhat', 'centos', 'amazon')
  yum_package 'kibana' do
    version "#{node['wazuh-elastic']['elastic_stack_version']}-1"
  end
else
  raise "Currently platforn not supported yet. Check out for updates in www.github.com/wazuh/wazuh-chef"
end

template 'kibana.yml' do
  path '/etc/kibana/kibana.yml'
  source 'kibana.yml.erb'
  owner 'root'
  group 'root'
  variables({
     kibana_server_port: "server.port: #{node['wazuh-elastic']['kibana_server_port']}",
     kibana_server_host: "server.host: #{node['wazuh-elastic']['kibana_server_host']}",
     kibana_elasticsearch_server_hosts: "elasticsearch.hosts: ['#{node['wazuh-elastic']['kibana_elasticsearch_server_hosts']}']"
  })
  mode 0755
end

case 
when "debian", "ubuntu"
  service "kibana" do
    supports :start => true, :stop => true, :restart => true, :reload => true
    action [:restart]
  end
when "redhat", "rhel", "centos"
  service "kibana" do
    supports :start => true, :stop => true, :restart => true, :reload => true
    provider Chef::Provider::Service::Init
    action [:restart]
  end
end



ruby_block 'wait for elasticsearch' do
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


if platform_family?('debian', 'ubuntu')
  bash 'Install Wazuh-APP (can take a while)' do
    code <<-EOH
    sudo -u kibana /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/wazuhapp/wazuhapp-#{node['wazuh-elastic']['wazuh_app_version']}.zip kibana
    EOH
    creates '/usr/share/kibana/plugins/wazuh/package.json'
    notifies :restart, "service[kibana]", :delayed
  end
elsif platform_family?('rhel', 'redhat', 'centos', 'amazon')
  bash 'Install Wazuh-APP (can take a while)' do
    code <<-EOH
    sudo -u kibana /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/wazuhapp/wazuhapp-#{node['wazuh-elastic']['wazuh_app_version']}.zip
    EOH
    creates '/usr/share/kibana/plugins/wazuh/package.json'
    notifies :restart, "service[kibana]", :delayed
  end
end

bash 'Verify Kibana folders owner' do
  code <<-EOF
    chown -R kibana:kibana /usr/share/kibana/optimize
    chown -R kibana:kibana /usr/share/kibana/plugins
  EOF

end