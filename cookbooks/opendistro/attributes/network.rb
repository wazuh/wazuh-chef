# frozen_string_literal: true

# Cookbook Name:: opendistro
# Attributes:: network
# Author:: Wazuh <info@wazuh.com>

# Instance configuration file

default['network'] = {
    'elasticsearch' => {
        'ip' => '<ELASTICSEARCH_IP>',
        'port' => '<ELASTICSEARCH_PORT>',
        'user' => '<ELASTICSEARCH_USER>',
        'password' => '<ELASTICSEARCH_PASSWORD>',
    },
    'kibana' => {
        'ip' => '<KIBANA_IP>',
        'port' => '<KIBANA_PORT>'
    },
    'wazuh' => {
        'ip' => '<WAZUH_IP>',
        'port' => '<WAZUH_API_PORT>'
    }
}
