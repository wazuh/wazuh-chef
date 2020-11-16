#
# Cookbook Name:: filebeat
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

# Install Filebeat package

if platform_family?('debian','ubuntu')
  package 'lsb-release'
  ohai 'reload lsb' do
    plugin 'lsb'
    # action :nothing
    subscribes :reload, 'package[lsb-release]', :immediately
  end
			
  apt_package 'filebeat' do
    only_if do
      File.exists?("/etc/apt/sources.list.d/wazuh.list")
    end
  end
elsif platform_family?('rhel', 'redhat', 'centos', 'amazon')
  yum_package 'filebeat' do
    only_if do
      File.exists?("/etc/yum.repos.d/wazuh.repo")
    end
  end
elsif platform_family?('suse')
  yum_package 'filebeat' do
    only_if do
      File.exists?("/etc/zypp/repos.d/wazuh.repo")
    end
  end
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end

# Edit the file /etc/filebeat/filebeat.yml
template node['filebeat']['config_path'] do
  source 'filebeat.yml.erb'
  owner 'root'
  group 'root'
  mode '0640'
  variables(output_elasticsearch_hosts: "hosts: [\"#{node['filebeat']['elasticsearch_server_ip']}:#{node['filebeat']['elasticsearch_server_port']}\"]")
end

# Download the alerts template for Elasticsearch:
bash 'Download alerts template' do
  code <<-EOH
    curl -so /etc/filebeat/wazuh-template.json https://raw.githubusercontent.com/wazuh/wazuh/4.0/extensions/elasticsearch/7.x/wazuh-template.json
    chmod go+r /etc/filebeat/wazuh-template.json
  EOH
end

# Download the Wazuh module for Filebeat:
bash 'Import Wazuh module for filebeat' do 
  code <<-EOH
    curl -s "https://packages.wazuh.com/4.x/filebeat/#{node['filebeat']['wazuh_filebeat_module']}" | tar -xvz -C /usr/share/filebeat/module
  EOH
end

# Change module permission 
directory '/usr/share/filebeat/module/wazuh' do
  mode '0755'
  recursive true
end
=begin
# Configure Filebeat certificates

bash 'Configure Filebeat certificates' do
  code <<-EOH
    mkdir /etc/filebeat/certs
    cp /etc/elasticsearch/certs/certs.tar /etc/filebeat/certs/
    cd /etc/filebeat/certs/
    tar --extract --file=certs.tar filebeat.pem filebeat.key root-ca.pem
    rm certs.tar
  EOH

end

service node['filebeat']['service_name'] do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end
=end
