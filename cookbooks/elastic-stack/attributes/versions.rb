# frozen_string_literal: true

# Cookbook Name:: elastic-stack
# Attributes:: versions
# Author:: Wazuh <info@wazuh.com>

# ELK
default['elk']['major_version'] = '7.x'
default['elk']['patch_version'] = '7.11.2'

# Wazuh
default['wazuh']['major_version'] = '4.x'
default['wazuh']['minor_version'] = '4.3'
default['wazuh']['patch_version'] = '4.3.0'

# Kibana
default['wazuh']['kibana_plugin_version'] = '4.3.0_7.10.2'
