#
# Cookbook Name:: ossec
# Recipe:: common
#
# Copyright 2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Gyoku renders the XML.
chef_gem 'gyoku' do
  compile_time false if respond_to?(:compile_time)
end

if platform_family?('mac_os_x')
  file "#{node['ossec']['dir']}/etc/ossec.conf" do
    owner 'root'
    group 'wazuh'
    mode '0440'
    manage_symlink_source true
    notifies :restart, 'service[com.wazuh.agent]'
    content lazy {
      all_conf = node['ossec']['conf'].to_hash
      Chef::OSSEC::Helpers.ossec_to_xml('ossec_config' => all_conf)
    }
  end
else
  file "#{node['ossec']['dir']}/etc/ossec.conf" do
    owner 'root'
    group 'wazuh'
    mode '0440'
    manage_symlink_source true
    notifies :restart, 'service[wazuh]'
    content lazy {
      all_conf = node['ossec']['conf'].to_hash
      Chef::OSSEC::Helpers.ossec_to_xml('ossec_config' => all_conf)
    }
  end
end


file "#{node['ossec']['dir']}/etc/shared/agent.conf" do
  owner 'root'
  group 'wazuh'
  mode '0440'
  notifies :restart, 'service[wazuh]'
  action :create
end
