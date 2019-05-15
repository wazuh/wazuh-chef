#
# Cookbook Name:: wazuh-elastic
# Recipe:: logstash_install

######################################################

case node['platform_family']
when 'debian'
  package 'logstash' do
    version '1:'+node['wazuh-elastic']['elastic_stack_version']+'-1'
  end
when 'rhel'
  package 'logstash' do
    version node['wazuh-elastic']['elastic_stack_version']
  end
end

ssl = begin
        Chef::EncryptedDataBagItem.load('wazuh_secrets', 'logstash_certificate')
      rescue Net::HTTPServerException
        {'logstash_certificate' => ""}
  
      end

file '/etc/logstash/logstash.crt' do
  mode '0544'
  owner 'root'
  group 'root'
  content ssl['logstash_certificate'].to_s
  action :create
end

case node['wazuh-elastic']['logstash_configuration']
when "local"
  bash 'Loading logstash local configuration...' do
    code <<-EOF
    curl -so /etc/logstash/conf.d/01-wazuh.conf https://raw.githubusercontent.com/wazuh/wazuh/3.9/extensions/logstash/01-wazuh-local.conf
    usermod -a -G ossec logstash
    sed -i 's|localhost:9200|'#{node['wazuh-elastic']['elasticsearch_ip']}:#{node['wazuh-elastic']['elasticsearch_port']}'|g' /etc/logstash/conf.d/01-wazuh.conf
    EOF
  end

when "remote"
  bash 'Loading logstash local configuration...' do
    code <<-EOF
    curl -so /etc/logstash/conf.d/01-wazuh.conf https://raw.githubusercontent.com/wazuh/wazuh/3.9/extensions/logstash/01-wazuh-remote.conf 
    sed -i 's|localhost:9200|'#{node['wazuh-elastic']['elasticsearch_ip']}:#{node['wazuh-elastic']['elasticsearch_port']}'|g' /etc/logstash/conf.d/01-wazuh.conf 
    EOF
  end
end

file '/etc/logstash/logstash.key' do
  mode '0544'
  owner 'root'
  group 'root'
  content ssl['logstash_certificate_key'].to_s
  action :create
end

service 'logstash' do
  action [:enable, :start]
end
