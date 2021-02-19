# frozen_string_literal: true

# Cookbook Name:: elastic-stack
# Attributes:: xpack
# Author:: Wazuh <info@wazuh.com>

default['xpack'] = {
    'enabled' => true,
    'verification_mode' => 'certificate',
    'elasticsearch' => {
        'key' => "#{node['elastic']['certs_path']}/elasticsearch.key",
        'cert' => "#{node['elastic']['certs_path']}/elasticsearch.crt",
        'ca' => "#{node['elastic']['certs_path']}/ca/ca.crt"
    },
    'kibana' => {
        'ca' => "#{node['kibana']['certs_path']}/ca/ca.crt",
        'cert' => "#{node['kibana']['certs_path']}/kibana.crt",
        'key' => "#{node['kibana']['certs_path']}/kibana.key"
    }
}
