# frozen_string_literal: true

# Cookbook Name:: elastic-stack
# Attributes:: versions
# Author:: Wazuh <info@wazuh.com>

# ELK
default['elk']['major_version'] = '7.x'
default['elk']['patch_version'] = '7.9.3'

# Wazuh
default['wazuh']['major_version'] = '4.x'
default['wazuh']['minor_version'] = '4.0'
default['wazuh']['patch_version'] = '4.0.3'

# Kibana
default['wazuh']['kibana_plugin_version'] = '4.0.3_7.9.3'
