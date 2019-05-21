default['ossec']['conf']['command'] = [
    {
        'name' => 'disable-account',
        'executable' => 'disable-account.sh',
        'expect' => 'user',
        'timeout_allowed' => 'yes'
    },
    {
        'content!' => {
            'name' => 'restart-ossec',
            'executable' => 'restart-ossec.sh',
            'expect' => ''
            }
    },
    {
      'content!' => {
        'name' => 'firewall-drop',
        'executable' => 'firewall-drop.sh',
        'expect' => 'srcip',
        'timeout_allowed' => 'yes'
     }
    },
    {
      'content!' => {
        'name' => 'host-deny',
        'executable' => 'host-deny.sh',
        'expect' => 'srcip',
        'timeout_allowed' => 'yes'
     }
    },
    {
      'content!' => {
        'name' => 'route-null',
        'executable' => 'route-null.sh',
        'expect' => 'srcip',
        'timeout_allowed' => 'yes'
     }
    },
    {
        'content!' => {
          'name' => 'win_route-null',
          'executable' => 'win_route-null.cmd',
          'expect' => 'srcip',
          'timeout_allowed' => 'yes'
       }
    },
    {
        'content!' => {
            'name' => 'win_route-null-2012',
            'executable' => 'route-null_2012.cmd',
            'expect' => 'srcip',
            'timeout_allowed' => 'yes'
        }
    },
    {
        'content!' => {
            'name' => 'netsh',
            'executable' => 'netsh.cmd',
            'expect' => 'srcip',
            'timeout_allowed' => 'yes'
        }
    },
    {
        'content!' => {
            'name' => 'netsh-win-2016',
            'executable' => 'netsh-win-2016.cmd',
            'expect' => 'srcip',
            'timeout_allowed' => 'yes'
        }
    }
]
