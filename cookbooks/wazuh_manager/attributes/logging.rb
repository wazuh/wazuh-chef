# Cookbook Name:: wazuh-manager
# Attributes:: logging
# Author:: Wazuh <info@wazuh.com

# Choose between plain or json format (or both) for internal logs
default['ossec']['conf']['logging'] = {
    'log_format' => 'plain'
}