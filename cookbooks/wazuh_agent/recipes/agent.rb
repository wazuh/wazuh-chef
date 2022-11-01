#
# Cookbook Name:: ossec
# Recipe:: agent_auth
#
# Copyright 2015, Opscode, Inc.
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

include_recipe 'wazuh_agent::repository'

case node['platform']
when 'debian', 'ubuntu'
  apt_package 'wazuh-agent' do
    version "#{node['wazuh']['patch_version']}-1"
  end
when 'redhat', 'centos', 'amazon', 'fedora', 'oracle'
  if node['platform_version'] >= '8'
    dnf_package 'wazuh-agent' do
      version "#{node['wazuh']['patch_version']}"
    end
  else
    yum_package 'wazuh-agent' do
      version "#{node['wazuh']['patch_version']}"
    end
  end
when 'opensuseleap', 'suse' 
  zypper_package 'wazuh-agent' do
    version "#{node['wazuh']['patch_version']}"
  end
when 'mac_os_x'
  bash 'install wazuh agent' do
    user 'root'
    code <<-EOH
    curl -o https://packages.wazuh.com/4.x/macos/wazuh-agent-#{node['wazuh']['patch_version']}-1.pkg && \
    installer -pkg wazuh-agent-#{node['wazuh']['patch_version']}-1.pkg -target /
    EOH
  end
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end

dir = node['ossec']['dir']
agent_auth = node['ossec']['agent_auth']

args = "-m #{agent_auth['host']} -p #{agent_auth['port']} -A #{agent_auth['name']}"

if agent_auth['auto_negotiate']
  args << ' -a ' + agent_auth['auto_negotiate']
end

if agent_auth['cipher_list']
  args << ' -c ' + agent_auth['cipher_list']
end

if agent_auth['wazuh_directory']
  args << ' -D ' + agent_auth['wazuh_directory']
end

if agent_auth['debug_mode'] == "true"
  args << ' -d '
end

if agent_auth['run_as_group']
  args << ' -g ' + agent_auth['run_as_group']
end

if agent_auth['set_group']
  args << ' -G ' + agent_auth['set_group']
end

if agent_auth['agent_ip_by_manager'] == "true"
  args << ' -i '
end

if agent_auth['agent_ip']
  args << ' -I ' + agent_auth['agent_ip']
end

if agent_auth['password']
  args << ' -P ' + agent_auth['password']
end

if agent_auth['ca'] && File.exist?(agent_auth['ca'])
  args << ' -v ' + agent_auth['ca']
end

if agent_auth['certificate'] && File.exist?(agent_auth['certificate'])
  args << ' -x ' + agent_auth['certificate']
end

if agent_auth['key'] && File.exist?(agent_auth['key'])
  args << ' -k ' + agent_auth['key']
end

execute 'wazuh agent auth' do
  command "#{dir}/bin/agent-auth #{args}"
  timeout 30
  ignore_failure node['ossec']['ignore_failure']
  only_if { agent_auth['register'] == 'yes' && agent_auth['host'] && !File.size?("#{dir}/etc/client.keys") }
  sensitive true
end

include_recipe 'wazuh_agent::common'

template "#{node['ossec']['dir']}/etc/local_internal_options.conf" do
  source 'var/ossec/etc/agent_local_internal_options.conf'
  owner 'root'
  group 'wazuh'
  action :create
end

service 'wazuh' do
  service_name 'wazuh-agent'
  supports status: true, restart: true
  action [:enable, :restart]
end
