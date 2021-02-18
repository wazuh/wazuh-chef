# Cookbook Name:: wazuh-manager
# Attributes:: global
# Author:: Wazuh <info@wazuh.com

default['ossec']['conf']['global'] = {
    'jsonout_output' => true,
    'alerts_log' => true,
    'logall' => false,
    'logall_json' => false,
    'email_notification' => false,
    'smtp_server' => 'smtp.example.wazuh.com',
    'email_from' => 'ossecm@example.wazuh.com',
    'email_to' => 'recipient@example.wazuh.com',
    'email_maxperhour' => 12,
    'email_log_source' => "alerts.log",
    'white_list' => [ 
        '127.0.0.1', 
        '^localhost.localdomain$', 
        '127.0.0.53'
    ],
    'agents_disconnection_time' => '20s',
    'agents_disconnection_alert_time' => '100s'
}
