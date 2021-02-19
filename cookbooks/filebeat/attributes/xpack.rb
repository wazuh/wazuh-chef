# frozen_string_literal: true

# Cookbook Name:: filebeat
# Attributes:: xpack
# Author:: Wazuh <info@wazuh.com>

default['xpack'] = {
    'enabled' => true,
    'verification_mode' => 'certificate',
    'ca' => "#{node['filebeat']['certs_path']}/ca/ca.crt",
    'cert' => "#{node['filebeat']['certs_path']}/filebeat.crt",
    'key' => "#{node['filebeat']['certs_path']}/filebeat.key"
}
