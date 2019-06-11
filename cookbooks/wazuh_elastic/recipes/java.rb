#
# Cookbook Name:: wazuh-elastic
# Recipe:: java

# Create user and group
#
if platform_family?('debian','ubuntu')
  package 'lsb-release'

  ohai 'reload lsb' do
    plugin 'lsb'
    # action :nothing
    subscribes :reload, 'package[lsb-release]', :immediately
  end

  apt_update 'update'

  if platform_family?('ubuntu')
    apt_repository 'java' do
      uri 'ppa:openjdk-r/java'
      distribution node['lsb']['codename']
      not_if {node['platform_version'].to_f > 16.0}
    end

    apt_update 'update'

    package 'openjdk-8-jre'
  else

    apt_update 'update'

    package 'openjdk-8-jdk'
  end

elsif platform_family?('centos','rhel','amazon','redhat')
  yum_package 'java-1.8.0-openjdk'
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end
