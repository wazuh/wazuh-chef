#
# Cookbook Name:: wazuh-elastic
# Recipe:: logstash_install

######################################################

if platform_family?('ubuntu', 'debian')
  apt_package 'logstash' do
    version "1:#{node['wazuh-elastic']['elastic_stack_version']}-1"
  end
elsif platform_family?('rhel','centos', 'amazon')
  yum_package 'logstash' do
    version "#{node['wazuh-elastic']['elastic_stack_version']}-1"
  end
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end

case node['wazuh-elastic']['logstash_configuration'] #
when "local"
  bash 'Loading logstash local configuration...' do 
    code <<-EOF
    curl -so /etc/logstash/conf.d/01-wazuh.conf https://raw.githubusercontent.com/wazuh/wazuh/#{node['wazuh-elastic']['extensions_version']}/extensions/logstash/6.x/01-wazuh-local.conf
    usermod -a -G ossec logstash
    sed -i 's|localhost:9200|'#{node['wazuh-elastic']['elasticsearch_ip']}:#{node['wazuh-elastic']['elasticsearch_port']}'|g' /etc/logstash/conf.d/01-wazuh.conf
    EOF
  end

when "remote"
  bash 'Loading logstash remote configuration...' do
    code <<-EOF
    curl -so /etc/logstash/conf.d/01-wazuh.conf https://raw.githubusercontent.com/wazuh/wazuh/#{node['wazuh-elastic']['extensions_version']}/extensions/logstash/6.x/01-wazuh-remote.conf 
    sed -i 's|localhost:9200|'#{node['wazuh-elastic']['elasticsearch_ip']}:#{node['wazuh-elastic']['elasticsearch_port']}'|g' /etc/logstash/conf.d/01-wazuh.conf 
    EOF
  end
end

service "logstash" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [:enable, :start]
end


ruby_block 'wait for elasticsearch' do
  block do
    loop { break if (TCPSocket.open("#{node['wazuh-elastic']['elasticsearch_ip']}",node['wazuh-elastic']['elasticsearch_port']) rescue nil); puts "Waiting for elasticsearch to start"; sleep 5 }
  end
end

bash 'Waiting for elasticsearch Socket...' do
  code <<-EOH
  until (curl -XGET http://#{node['wazuh-elastic']['elasticsearch_ip']}:#{node['wazuh-elastic']['elasticsearch_port']}); do
    printf 'Waiting for elasticsearch....'
    sleep 5
  done
  EOH
end

begin
  ssl = Chef::EncryptedDataBagItem.load('wazuh_secrets', 'logstash_certificate')
  log "Logstash certificate found, writing... (Note: Disabled by default) " do
    message "-----LOGSTASH CERTIFICATE FOUND-----"
    level :info
  end
rescue ArgumentError, Net::HTTPServerException
  ssl = {'logstash_certificate' => "", 'logstash_certificate_key' => ""}
  log "No logstash certificate found...Installation will continue with empty certificate (Note: Disabled by default)" do
    message "-----LOGSTASH CERTIFICATE NOT FOUND-----"
    level :info
  end
end

file '/etc/logstash/logstash.crt' do
  mode '0644'
  owner 'root'
  group 'root'
  content ssl['logstash_certificate'].to_s
  action :create
  notifies :restart, "service[logstash]", :immediately
end

file '/etc/logstash/logstash.key' do
  mode '0644'
  owner 'root'
  group 'root'
  content ssl['logstash_certificate_key'].to_s
  action :create
  notifies :restart, "service[logstash]", :immediately
end
