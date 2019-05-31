
case node['platform_family'] 
when "debian","ubuntu"
  default['ossec']['conf']['localfile'] = [
    {
      'log_format' => 'command',
      'command' => 'df -P',
      'frequency' => 360
    },
    {
      'content!' => {
        'log_format' => 'full_command',
        'command' => "netstat -tulpn | sed 's/\([[:alnum:]]\+\)\ \+[[:digit:]]\+\ \+[[:digit:]]\+\ \+\(.*\):\([[:digit:]]*\)\ \+\([0-9\.\:\*]\+\).\+\ \([[:digit:]]*\/[[:alnum:]\-]*\).*/\1 \2 == \3 == \4 \5/' | sort -k 4 -g | sed 's/ == \(.*\) ==/:\1/' | sed 1,2d",
        'alias' => 'netstat listening ports',
        'frequency' => 360
      }
    },
    {
      'content!' => {
      'log_format' => 'full_command',
      'command' => 'last -n 20',
      'frequency' => 360
      }
    },
    {
      'content!' => {
        'log_format' => 'syslog',
        'location' => '/var/ossec/logs/active-responses.log',
      }
    },
    {
      'content!' => {
        'log_format' => 'syslog',
        'location' => '/var/log/auth.log'
        }
    },
    {
      'content!' => {
        'log_format' => 'syslog',
        'location' => '/var/log/syslog'
        }
    },
    {
      'content!' => {
        'log_format' => 'syslog',
        'location' => '/var/log/dpkg.log'
        }
    },
    {
      'content!' => {
        'log_format' => 'syslog',
        'location' => '/var/log/kern.log'
        }
    }
  ]

when "centos","redhat","rhel"

  default['ossec']['conf']['localfile'] = [
    {
      'log_format' => 'command',
      'command' => 'df -P',
      'frequency' => 360
    },
    {
      'content!' => {
        'log_format' => 'full_command',
        'command' => "netstat -tulpn | sed 's/\([[:alnum:]]\+\)\ \+[[:digit:]]\+\ \+[[:digit:]]\+\ \+\(.*\):\([[:digit:]]*\)\ \+\([0-9\.\:\*]\+\).\+\ \([[:digit:]]*\/[[:alnum:]\-]*\).*/\1 \2 == \3 == \4 \5/' | sort -k 4 -g | sed 's/ == \(.*\) ==/:\1/' | sed 1,2d",
        'alias' => 'netstat listening ports',
        'frequency' => 360
      }
    },
    {
      'content!' => {
      'log_format' => 'full_command',
      'command' => 'last -n 20',
      'frequency' => 360
      }
    },
    {
      'content!' => {
        'log_format' => 'syslog',
        'location' => '/var/ossec/logs/active-responses.log',
      }
    },
    {
      'content!' => {
        'log_format' => 'syslog',
        'location' => '/var/log/messages'
        }
    },
    {
      'content!' => {
        'log_format' => 'syslog',
        'location' => '/var/log/secure'
        }
    },
  ]
end







