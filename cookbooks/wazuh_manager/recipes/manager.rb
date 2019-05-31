#
# Cookbook Name:: wazuh
# Recipe:: manager
#
# Copyright 2015, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#include_recipe 'chef-sugar::default'

case node['platform_family']
when "debian", "ubuntu"
  apt_package 'wazuh-manager' do
    version "#{node['wazuh-manager']['version']}-1"
  end
when "redhat", "rhel", "centos"
  yum_package 'wazuh-manager' do
    version "#{node['wazuh-manager']['version']}-1"
  end
end

# The dependences should be installed only when the cluster is enabled
if node['ossec']['conf']['cluster']['disabled'] == 'no'
 case node['platform']
  when 'debian', 'ubuntu'
    log 'Wazuh_Cluster_not_compatible' do
      message "Wazuh cluster is not compatible with this version with #{node['platform']}"
      level :warn
    end
  when 'redhat', 'centos'
    if node['platform_version'].to_i == 7
      package ['python-setuptools', 'python-cryptography']
    end
  end
end

# Auth need to be enable only in master node.
if node['ossec']['conf']['cluster']['node_type'] == 'master'
  execute 'Enable Authd' do
    command '/var/ossec/bin/ossec-control enable auth'
    not_if "ps axu | grep ossec-authd | grep -v grep"
  end
end

include_recipe 'wazuh_manager::common'
include_recipe 'wazuh_manager::wazuh_api'

template "#{node['ossec']['dir']}/etc/local_internal_options.conf" do
  source 'var/ossec/etc/manager_local_internal_options.conf'
  owner 'root'
  group 'ossec'
  action :create
end

template "#{node['ossec']['dir']}/etc/rules/local_rules.xml" do
  source 'ossec_local_rules.xml.erb'
  owner 'root'
  group 'ossec'
  mode '0640'
end


template "#{node['ossec']['dir']}/etc/decoders/local_decoder.xml" do
  source 'ossec_local_decoder.xml.erb'
  owner 'root'
  group 'ossec'
  mode '0640'
end

service 'wazuh' do
  service_name 'wazuh-manager'
  supports :status => true, :restart => true, :reload => true
  action [:enable, :restart]
end
