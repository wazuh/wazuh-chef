# frozen_string_literal: true

# Cookbook Name:: elastis-stack
# Recipe:: prerequisites
# Author:: Wazuh <info@wazuh.com>

case node['platform']
when 'debian', 'ubuntu'
  apt_package 'unzip' do
    action :install
  end

  apt_package 'curl' do
    action :install
  end

  apt_package 'apt-transport-https' do
    action :install
  end
when 'redhat', 'centos', 'amazon', 'fedora', 'oracle'
  if node['platform_version'] >= '8'
    dnf_package 'unzip' do
      action :install
    end

    dnf_package 'curl' do
      action :install
    end

    dnf_package 'libcap' do
      action :install
    end
  else
    yum_package 'unzip' do
      action :install
    end

    yum_package 'curl' do
      action :install
    end

    yum_package 'libcap' do
      action :install
    end
  end
when 'opensuseleap', 'suse'
  zypper_package 'unzip' do
    action :install
  end

  zypper_package 'curl' do
    action :install
  end

  zypper_package 'libcap2' do
    action :install
  end
else
  raise 'Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added'
end
