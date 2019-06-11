# -*- encoding: utf-8 -*-
#
# Cookbook Name:: wazuh-elastic
# Recipe:: elasticsearch_install
#
######################################################


if platform_family?('debian', 'ubuntu')

  apt_package 'elasticsearch' do
    version "#{node['wazuh-elastic']['elastic_stack_version']}"
  end

elsif platform_family?('rhel', 'redhat', 'centos', 'amazon')
  yum_package 'elasticsearch' do
    version "#{node['wazuh-elastic']['elastic_stack_version']}-1"
  end

else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end

template '/etc/elasticsearch/elasticsearch.yml' do
  source 'elasticsearch.yml.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0660'
  variables({hostname: node['hostname'],
            clustername: node['wazuh-elastic']['elasticsearch_cluster_name'],
            ip:  node['wazuh-elastic']['elasticsearch_ip'],
            port: node['wazuh-elastic']['elasticsearch_port']})
end

## Setting heap to half of the RAM available is the recommended by official ES documentation.

half = ((node['memory']['total'].to_i * 0.5).floor / 1024)
node.default['wazuh_elastic']['elasticsearch_memmory'] = (half > 30_500 ? '30500m' : "#{half}m")

template '/etc/elasticsearch/jvm.options' do
  source 'jvm.options.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0660'
  variables({memmory: node['wazuh-elastic']['elasticsearch_memmory']})
end

bash 'insert_line_limits.conf' do
  code <<-EOH
  echo "elasticsearch - nofile  65535" >> /etc/security/limits.conf
  echo "elasticsearch - memlock unlimited" >> /etc/security/limits.conf
  EOH
  not_if "grep -q elasticsearch /etc/security/limits.conf"
end

service "elasticsearch" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [:enable, :start]
end

ruby_block 'wait for elasticsearch' do
  block do
    loop { break if (TCPSocket.open("#{node['wazuh-elastic']['elasticsearch_ip']}",node['wazuh-elastic']['elasticsearch_port']) rescue nil); puts "Waiting for elasticsearch to start"; sleep 5 }
  end
end

bash 'Elasticsearch_template' do
  code <<-EOH
  curl https://raw.githubusercontent.com/wazuh/wazuh/#{node['wazuh-elastic']['extensions_version']}/extensions/elasticsearch/6.x/wazuh-template.json | curl -X PUT 'http://#{node['wazuh-elastic']['elasticsearch_ip']}:#{node['wazuh-elastic']['elasticsearch_port']}/_template/wazuh' -H 'Content-Type: application/json' -d @-
  EOH
  not_if "curl -XGET 'http://#{node['wazuh-elastic']['elasticsearch_ip']}:#{node['wazuh-elastic']['elasticsearch_port']}/_template/wazuh' | grep wazuh"
  notifies :restart, "service[elasticsearch]", :immediately
end


