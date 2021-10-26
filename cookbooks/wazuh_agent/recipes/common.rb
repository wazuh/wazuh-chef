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

#ruby_block 'ossec install_type' do
#  block do
#    File.open('/var/ossec/etc/ossec-init.conf') do |file|
#      file.each_line do |line|
#        if line =~ /^TYPE="([^"]+)"/
#          type = Regexp.last_match(1)
#          break
#        end
#      end
#    end
#  end
#end

# Gyoku renders the XML.
chef_gem 'gyoku' do
  compile_time false if respond_to?(:compile_time)
end

file "#{node['ossec']['dir']}/etc/ossec.conf" do
  owner 'root'
  group 'ossec'
  mode '0440'
  manage_symlink_source true
  notifies :restart, 'service[wazuh]'

  content lazy {
    all_conf = node['ossec']['conf'].to_hash
    Chef::OSSEC::Helpers.ossec_to_xml('ossec_config' => all_conf)
  }

end

file "#{node['ossec']['dir']}/etc/shared/agent.conf" do
  owner 'root'
  group 'ossec'
  mode '0440'
  notifies :restart, 'service[wazuh]'
  action :create
end
