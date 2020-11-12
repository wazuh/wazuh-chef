#
# Cookbook Name:: filebeat
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>


if platform_family?('debian','ubuntu')
  package 'lsb-release'

  ohai 'reload lsb' do
    plugin 'lsb'
    # action :nothing
    subscribes :reload, 'package[lsb-release]', :immediately
  end

 apt_repository 'Elastic OSS 7.x Apt Repository' do
    uri 'https://artifacts.elastic.co/packages/oss-7.x/apt'
    key 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
    distribution "stable"
    components ["main"]
    action :create
    not_if do
      File.exists?("/etc/apt/sources.list.d/elastic-7.x.list")
    end
  end
elsif platform_family?('rhel', 'redhat', 'centos', 'amazon')
  yum_repository 'Elastic OSS 7.x Yum Repository'
    baseurl "https://artifacts.elastic.co/packages/oss-7.x/yum"
    gpgkey "https://artifacts.elastic.co/GPG-KEY-elasticsearch"
    action :create
    not_if do
      File.exists?("/etc/yum/sources.list.d/elastic-7.x.list")
    end
  end
elsif platform_family?('suse')
  zypper_repository 'Elastic OSS 7.x Yum Repository'
    baseurl "https://artifacts.elastic.co/packages/oss-7.x/yum"
    gpgkey "https://artifacts.elastic.co/GPG-KEY-elasticsearch"
    action :create
    not_if do
      File.exists?("/etc/yum/sources.list.d/elastic-7.x.list")
    end
  end
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end

