# Cookbook Name:: wazuh_elastic
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

case node['platform_family']
when 'debian'
  package 'lsb-release'

  ohai 'reload lsb' do
    plugin 'lsb'
    # action :nothing
    subscribes :reload, 'package[lsb-release]', :immediately
  end

  apt_repository 'elastic-5.x' do
    uri 'https://artifacts.elastic.co/packages/6.x/apt'
    key 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
    distribution "stable"
    components ["main"]
    not_if do
      File.exists?("/etc/apt/sources.list.d/elastic-6.x.list")
    end
  end
when 'rhel'
  yum_repository 'elastic-5.x' do
    description 'Elastic repository for 6.x packages'
    baseurl 'https://artifacts.elastic.co/packages/6.x/yum'
    gpgkey 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
    action :create
  end
end
