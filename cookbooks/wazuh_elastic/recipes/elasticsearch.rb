# -*- encoding: utf-8 -*-
#
# Cookbook Name:: wazuh-elastic
# Recipe:: elasticsearch_install
#
######################################################

# Install opendistroforelasticsearch

if platform_family?('debian', 'ubuntu')
  apt_package %(elasticsearch-oss opendistroforelasticsearch)
elsif platform_family?('rhel', 'redhat', 'centos', 'amazon')
  yum_package 'opendistroforelasticsearch'
elsif platform_family?('suse')
  zypper_package 'opendistroforelasticsearch'
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end

=begin
# Set up elasticsearch configuration file

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
=end

# Set up opendistro for elasticsearch configuration file

template '/etc/elasticsearch/elasticsearch.yml' do
  source 'od_elasticsearch.yml.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0660'
  variables ({
    network_host: "network.host: #{node['wazuh-elastic']['elasticsearch_ip']}",
    node_name: "node.name: #{node['wazuh-elastic']['elasticsearch_node_name']}",
    cluster_initial_master_nodes: "cluster.initial_master_nodes: #{node['wazuh-elastic']['elasticsearch_cluster_initial_master_nodes']}",
    path_data: "path.data: #{node['wazuh-elastic']['elasticsearch_path_data']}",
    path_logs: "path.logs: #{node['wazuh-elastic']['elasticsearch_path_logs']}",
  })
end

=begin
# Set up JVM config file

template '/etc/elasticsearch/jvm.options' do
  source 'jvm.options.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0660'
  variables({memmory: node['wazuh-elastic']['elasticsearch_memmory']})
end

# Set up limits.conf

bash 'insert_line_limits.conf' do
  code <<-EOH
  echo "elasticsearch - nofile  65535" >> /etc/security/limits.conf
  echo "elasticsearch - memlock unlimited" >> /etc/security/limits.conf
  EOH
  not_if "grep -q elasticsearch /etc/security/limits.conf"
end
=end
# Elasticsearch roles and users

remote_file '/usr/share/elasticsearch/plugins/opendistro_security/securityconfig/roles.yml' do
  source 'https://raw.githubusercontent.com/wazuh/wazuh-documentation/4.0/resources/open-distro/elasticsearch/roles/roles.yml'
end

remote_file '/usr/share/elasticsearch/plugins/opendistro_security/securityconfig/roles_mapping.yml' do
  source 'https://raw.githubusercontent.com/wazuh/wazuh-documentation/4.0/resources/open-distro/elasticsearch/roles/roles_mapping.yml'
end

remote_file '/usr/share/elasticsearch/plugins/opendistro_security/securityconfig/internal_users.yml' do
  source 'https://raw.githubusercontent.com/wazuh/wazuh-documentation/4.0/resources/open-distro/elasticsearch/roles/internal_users.yml'
end

# Certificates creation and deployment

execute 'Remove the demo certificates' do
  command 'rm /etc/elasticsearch/esnode-key.pem /etc/elasticsearch/esnode.pem /etc/elasticsearch/kirk-key.pem /etc/elasticsearch/kirk.pem /etc/elasticsearch/root-ca.pem -f'
end

directory '/etc/elasticsearch/certs' do
  action :create
end

remote_file '/tmp/search-guard-tlstool-1.8.zip' do
  source 'https://maven.search-guard.com/search-guard-tlstool/1.8/search-guard-tlstool-1.8.zip'
end

archive_file 'search-guard-tlstool-1.8.zip' do
  path '/tmp/search-guard-tlstool-1.8.zip'
  destination '/tmp/searchguard'
end

# --------------Wazuh single-node cluster--------------

template '/tmp/searchguard/search-guard.yml' do
  source 'search-guard.yml.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0660'
  variables ({
    elasticsearch_ip: "#{node['wazuh-elastic']['elasticsearch_ip']}",
    kibana_ip: "#{node['wazuh-elastic']['kibana_server_host']}"
  })
end

# --------------Wazuh multi-node cluster--------------
# ToDO
# ----------------------------------------------------

execute 'Run the Search Guard’s script to create the certificates' do
  command "/tmp/searchguard/tools/sgtlstool.sh -c /tmp/searchguard/search-guard.yml -ca -crt -t /etc/elasticsearch/certs/"
end

execute 'Compress all the necessary files to be sent to the all the instances' do
  command "tar -cf /etc/elasticsearch/certs/certs.tar /etc/elasticsearch/certs/*"
end

# In case of more than once instance, copy certs.tar to all of them

execute 'Remove unnecessary files' do
  command "rm /etc/elasticsearch/certs/client-certificates.readme /etc/elasticsearch/certs/elasticsearch_elasticsearch_config_snippet.yml /tmp/search-guard-tlstool-1.7.zip /etc/elasticsearch/certs/filebeat* -f"
end

# Run elasticsearch service

service "elasticsearch" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [:enable, :start]
end

ruby_block 'wait for elasticsearch' do
  block do
    loop { break if (TCPSocket.open("#{node['wazuh-elastic']['elasticsearch_ip']}",node['wazuh-elastic']['elasticsearch_port']) rescue nil); puts "Waiting for elasticsearch to start"; sleep 5 }
  end
end
=begin
bash 'Verify Elasticsearch folders owner' do
  code <<-EOF
    chown elasticsearch:elasticsearch -R /etc/elasticsearch
    chown elasticsearch:elasticsearch -R /usr/share/elasticsearch
    chown elasticsearch:elasticsearch -R /var/lib/elasticsearch
  EOF
  notifies :restart, "service[elasticsearch]", :delayed
end
=end

execute 'Run the Elasticsearch’s securityadmin script' do
  command  "/usr/share/elasticsearch/plugins/opendistro_security/tools/securityadmin.sh -cd /usr/share/elasticsearch/plugins/opendistro_security/securityconfig/ -nhnv -cacert /etc/elasticsearch/certs/root-ca.pem -cert /etc/elasticsearch/certs/admin.pem -key /etc/elasticsearch/certs/admin.key -h #{node['wazuh-elastic']['elasticsearch_ip']}"
end


