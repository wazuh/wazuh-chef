# Cookbook Name:: wazuh-manager
# Attributes:: sca
# Author:: Wazuh <info@wazuh.com

default['ossec']['conf']['sca'] = {
    'enabled' => true,
    'scan_on_start' => true,
    'interval' => "12h",
    'skip_nfs' => true
}