# frozen_string_literal: true

# Cookbook Name:: elastic-stack
# Attributes:: network
# Author:: Wazuh <info@wazuh.com>

# Instance configuration file

default['network'] = {
    'elasticsearch' => {
        'ip' => '<ELASTICSEARCH_IP>',
        'port' => '<ELASTICSEARCH_PORT>',
        'user' => '<ELASTICSEARCH_PASSWORD>',
        'password' => '<ELASTICSEARCH_PASSWORD>'
    }
}
