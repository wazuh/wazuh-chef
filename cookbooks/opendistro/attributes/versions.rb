# frozen_string_literal: true

# Cookbook Name:: opendistro
# Attributes:: versions
# Author:: Wazuh <info@wazuh.com>

# Elastic Stack
default['elk']['patch_version'] = '7.10.0'

# Opendistro
default['odfe']['patch_version'] = '1.12.0'

# Wazuh
default['wazuh']['major_version'] = '4.x'
default['wazuh']['minor_version'] = "4.1"
default['wazuh']['patch_version'] = "4.1.1"

# Kibana
default['wazuh']['kibana_plugin_version'] = '4.1.1_7.10.0'

# Search guard
default['searchguard']['version'] = '1.8'
