# Cookbook Name:: wazuh_elastic
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

if platform_family?('debian','ubuntu')
  package "lsb-release"

  ohai 'reload lsb' do
    plugin 'lsb'
    # action :nothing
    subscribes :reload, 'package[lsb-release]', :immediately
  end

  apt_repository 'elastic-6.x' do
    uri 'https://artifacts.elastic.co/packages/6.x/apt'
    key 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
    distribution "stable"
    components ["main"]
    not_if do
      File.exists?("/etc/apt/sources.list.d/elastic-6.x.list")
    end
  end  
elsif platform_family?('rhel', 'redhat', 'centos', 'amazon')
  yum_repository "elastic-6.x" do
    description "Elastic repository for 6.x packages"
    baseurl "https://artifacts.elastic.co/packages/6.x/yum"
    gpgkey "https://artifacts.elastic.co/GPG-KEY-elasticsearch"
    action :create
  end
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end