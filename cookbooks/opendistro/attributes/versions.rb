# frozen_string_literal: true

# Cookbook Name:: opendistro
# Attributes:: versions
# Author:: Wazuh <info@wazuh.com>

# Elastic Stack
default['elk']['patch_version'] = '7.9.1'

# Opendistro
default['odfe']['patch_version'] = '1.11.0'

# Wazuh
default['wazuh']['major_version'] = '4.x'
default['wazuh']['minor_version'] = '4.0'
default['wazuh']['patch_version'] = '4.0.3'

# Kibana
default['wazuh']['kibana_plugin_version'] = '4.0.3_7.9.1'

# Search guard
default['searchguard']['version'] = '1.8'
