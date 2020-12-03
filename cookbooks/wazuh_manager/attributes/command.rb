# Cookbook Name:: wazuh-manager
# Attributes:: command
# Author:: Wazuh <info@wazuh.com

default['ossec']['conf']['command'] = [
    {
        'name' => 'disable-account',
        'executable' => 'disable-account.sh',
        'expect' => 'user',
        'timeout_allowed' => true
    },
    {
        'name' => 'restart-ossec',
        'executable' => 'restart-ossec.sh',
        'expect' => ''
    },
    {
        'name' => 'firewall-drop',
        'executable' => 'firewall-drop.sh',
        'expect' => 'srcip',
        'timeout_allowed' => true
    },
    {
        'name' => 'host-deny',
        'executable' => 'host-deny.sh',
        'expect' => 'srcip',
        'timeout_allowed' => true
    },
    {
        'name' => 'route-null',
        'executable' => 'route-null.sh',
        'expect' => 'srcip',
        'timeout_allowed' => true
    },
    {
        'name' => 'win_route-null',
        'executable' => 'route-null.cmd',
        'expect' => 'srcip',
        'timeout_allowed' => true
    },
    {
        'name' => 'win_route-null-2012',
        'executable' => 'route-null_2012.cmd',
        'expect' => 'srcip',
        'timeout_allowed' => true
    },
    {
        'name' => 'netsh',
        'executable' => 'netsh.cmd',
        'expect' => 'srcip',
        'timeout_allowed' => true
    },
    {
        'name' => 'netsh-win-2016',
        'executable' => 'netsh-win-2016.cmd',
        'expect' => 'srcip',
        'timeout_allowed' => true
    }
]
