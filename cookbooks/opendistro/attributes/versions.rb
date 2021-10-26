# frozen_string_literal: true

# Cookbook Name:: opendistro
# Attributes:: versions
# Author:: Wazuh <info@wazuh.com>

# Elastic Stack
default['elk']['patch_version'] = '7.10.2'

# Opendistro
default['odfe']['patch_version'] = '1.13.2'

# Wazuh
default['wazuh']['major_version'] = '4.x'
default['wazuh']['minor_version'] = '4.2'
default['wazuh']['patch_version'] = '4.2.4'

# Kibana
default['wazuh']['kibana_plugin_version'] = '4.2.4_7.10.2'

# Search guard
default['searchguard']['version'] = '1.8'
