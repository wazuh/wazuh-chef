#
# Cookbook Name:: wazuh-elastic
# Recipe:: java

# Create user and group
#
case node['platform']
when 'ubuntu'
  package 'lsb-release'

  ohai 'reload lsb' do
    plugin 'lsb'
    # action :nothing
    subscribes :reload, 'package[lsb-release]', :immediately
  end

  apt_repository 'java' do
    uri 'ppa:openjdk-r/java'
    distribution node['lsb']['codename']
    not_if {node['platform_version'].to_f > 16.0}
  end

  apt_update 'update'
  package 'openjdk-8-jre'

when 'redhat', 'centos'

  yum_package 'java-1.8.0-openjdk'

end
