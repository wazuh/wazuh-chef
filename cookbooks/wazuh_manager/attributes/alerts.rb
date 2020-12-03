# Cookbook Name:: wazuh-manager
# Attributes:: alerts
# Author:: Wazuh <info@wazuh.com

default['ossec']['conf']['alerts'] = {
    'log_alert_level' => 3,
    'email_alert_level' => 12
}