# Cookbook Name:: wazuh-manager
# Attributes:: rule_test
# Author:: Wazuh <info@wazuh.com

# Rule test settings (Manager)
default['ossec']['conf']['rule_test'] = [
    'enabled' => true,
    'threads' => 1,
    'max_sessions' => 64,
    'session_timeout' => '15m'
]
