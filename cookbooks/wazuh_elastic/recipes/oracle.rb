#
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Cookbook:: java
# Recipe:: oracle
#
# Copyright:: 2011, Bryan w. Berry
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

include_recipe 'wazuh-elastic::notify'

unless node.recipe?('wazuh-elastic::default')
  Chef::Log.warn('Using wazuh-elastic::default instead is recommended.')

  # Even if this recipe is included by itself, a safety check is nice...
  if node['wazuh-elastic']['java_home'].nil? || node['wazuh-elastic']['java_home'].empty?
    include_recipe 'wazuh-elastic::set_attributes_from_version'
  end
end

java_home = node['wazuh-elastic']['java_home']
arch = node['wazuh-elastic']['arch']
version = node['wazuh-elastic']['jdk_version'].to_s
tarball_url = node['wazuh-elastic']['jdk'][version][arch]['url']
tarball_checksum = node['wazuh-elastic']['jdk'][version][arch]['checksum']
bin_cmds = node['wazuh-elastic']['jdk'][version]['bin_cmds']

include_recipe 'wazuh-elastic::set_java_home'

java_oracle_install 'jdk' do
  url tarball_url
  default node['wazuh-elastic']['set_default']
  checksum tarball_checksum
  app_home java_home
  bin_cmds bin_cmds
  alternatives_priority node['wazuh-elastic']['alternatives_priority']
  retries node['wazuh-elastic']['ark_retries']
  retry_delay node['wazuh-elastic']['ark_retry_delay']
  connect_timeout node['wazuh-elastic']['ark_timeout']
  use_alt_suffix node['wazuh-elastic']['use_alt_suffix']
  reset_alternatives node['wazuh-elastic']['reset_alternatives']
  download_timeout node['wazuh-elastic']['ark_download_timeout']
  proxy node['wazuh-elastic']['ark_proxy']
  action :install
  notifies :write, 'log[jdk-version-changed]', :immediately
end

if node['wazuh-elastic']['set_default'] && platform_family?('debian')
  include_recipe 'wazuh-elastic::default_java_symlink'
end

include_recipe 'wazuh-elastic::oracle_jce' if node['wazuh-elastic']['oracle']['jce']['enabled']
