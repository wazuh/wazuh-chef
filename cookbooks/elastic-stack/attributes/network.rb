# frozen_string_literal: true

# Cookbook Name:: elastic-stack
# Attributes:: network
# Author:: Wazuh <info@wazuh.com>

# Instance configuration file

default['network'] = {
    'elasticsearch' => {
        'ip' => '<ELASTICSEARCH_IP>',
        'port' => '<ELASTICSEARCH_PORT>',
        'password' => '<ELASTICSEARCH_PASSWORD>'
    },
    'kibana' => {
        'ip' => '<KIBANA_IP>',
        'port' => '<KIBANA_PORT>'
    },
    'wazuh' => {
        'ip' => '<WAZUH_IP>'
    }
}
