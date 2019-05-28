# -*- encoding: utf-8 -*-
#
# Cookbook Name:: wazuh-elastic
# Recipe:: elasticsearch_install
#
######################################################

package 'elasticsearch' do
    version node['wazuh-elastic']['elastic_stack_version']
    action :install
end


template '/etc/elasticsearch/elasticsearch.yml' do
  source 'elasticsearch.yml.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0660'
  variables({clustername: "cluster.name: #{node['wazuh-elastic']['elasticsearch_cluster_name']}",
            node_name: "node.name: #{node['wazuh-elastic']['elasticsearch_node_name']}",
            node_master: "node.master: #{node['wazuh-elastic']['elasticsearch_node_master']}",
            node_data: "node.data: #{node['wazuh-elastic']['elasticsearch_node_data']}",
            node_ingest: "node.ingest: #{node['wazuh-elastic']['elasticsearch_node_ingest']}",
            node_max_local_storage_nodes: "node.max_local_storage_nodes: #{node['wazuh-elastic']['elasticsearch_node_max_local_storage_nodes']}",
            cluster_remote_connect: "cluster.remote.connect: #{node['wazuh-elasticsearch']['elasticsearch_cluster_remote_connect']}",
            path_data: "path.data: #{node['wazuh-elastic']['elasticsearch_path_data']}",
            path_logs: "path.logs: #{node['wazuh-elastic']['elasticsearch_path_logs']}",
            network_host: "network.host: #{node['wazuh-elastic']['elasticsearch_ip']}",
            http_port: "http.port: #{node['wazuh-elastic']['elasticsearch_port']}",
            discovery_option: "#{node['wazuh-elastic']['elasticsearch_discovery_option']}",
            cluster_initial_master_nodes: "#{node['wazuh-elastic']['elasticsearch_cluster_initial_master_nodes']}" })
end

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

bash 'Verify Elasticsearch folders owner' do
  code <<-EOF
    chown elasticsearch:elasticsearch -R /etc/elasticsearch
    chown elasticsearch:elasticsearch -R /usr/share/elasticsearch
    chown elasticsearch:elasticsearch -R /var/lib/elasticsearch
  EOF
  notifies :restart, "service[elasticsearch]", :delayed
end


