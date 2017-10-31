#
# Cookbook Name:: ossec
# Attributes:: default
#
# Copyright 2010-2015, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# general settings
default['ossec']['dir'] = '/var/ossec'
default['ossec']['server_role'] = 'ossec_server'
default['ossec']['hostname_server_ip'] = nil
# CUSTOMIZE - Below customize the URL for sending messages
# to a specific Slack channel connection with slack
default['ossec']['hook_url'] = 'https://hooks.slack.com/services/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'
# to a specific pagerduty
default['ossec']['pagerduty_key'] = 'f25bc0a22b014829818f82ca33636454'
# The following attributes are mapped to XML for ossec.conf using
# Gyoku. See the README for details on how this works.

%w(local server).each do |type|

  # CUSTOMIZE - Specify the email from and to address,
  # as well as the DNS name of the SMTP server
  default['ossec']['conf'][type]['global']['jsonout_output'] = true
  default['ossec']['conf'][type]['global']['alerts_log'] = true
  default['ossec']['conf'][type]['global']['logall'] = false
  default['ossec']['conf'][type]['global']['email_notification'] = false
  default['ossec']['conf'][type]['global']['smtp_server'] = 'smtp.example.wazuh.com'
  default['ossec']['conf'][type]['global']['email_from'] = 'ossecm@example.wazuh.com'
  default['ossec']['conf'][type]['global']['email_to'] = 'recipient@example.wazuh.com'
  default['ossec']['conf'][type]['global']['email_maxperhour'] = 12
  # These are the IPs that will never be affected by Active Response
  default['ossec']['conf'][type]['global']['white_list'] = ['127.0.0.1', '^localhost.localdomain$', '8.8.8.8']

  default['ossec']['conf'][type]['alerts']['email_alert_level'] = 12
  default['ossec']['conf'][type]['alerts']['log_alert_level'] = 3
  #Choose between plain or json format (or both) for internal logs
  default['ossec']['conf'][type]['logging']['log_format'] = 'plain'

  # Authd configuration
  default['ossec']['conf'][type]['auth']['disabled'] = false
  default['ossec']['conf'][type]['auth']['port'] = 1515
  default['ossec']['conf'][type]['auth']['use_source_ip'] = true
  default['ossec']['conf'][type]['auth']['force_insert'] = true
  default['ossec']['conf'][type]['auth']['force_time'] = 0
  default['ossec']['conf'][type]['auth']['purge'] = false
  default['ossec']['conf'][type]['auth']['use_password'] = false
  #<ssl_agent_ca></ssl_agent_ca>
  default['ossec']['conf'][type]['auth']['ssl_verify_host'] = false
  default['ossec']['conf'][type]['auth']['ssl_manager_cert'] = "#{node['ossec']['dir']}/etc/sslmanager.cert"
  default['ossec']['conf'][type]['auth']['ssl_manager_key'] = "#{node['ossec']['dir']}/etc/sslmanager.key"
  default['ossec']['conf'][type]['auth']['ssl_auto_negotiate'] = false

  default['ossec']['conf'][type]['ruleset']['decoder_dir'] = ['ruleset/decoders', 'etc/decoders']
  default['ossec']['conf'][type]['ruleset']['rule_dir'] = ['ruleset/rules', 'etc/rules']
  default['ossec']['conf'][type]['ruleset']['rule_exclude'] = '0215-policy_rules.xml'
  default['ossec']['conf'][type]['ruleset']['list'] = 'etc/lists/audit-keys'

  default['ossec']['conf'][type]['remote']['connection'] = ['secure']
  default['ossec']['conf'][type]['remote']['port'] = "1514"
  default['ossec']['conf'][type]['remote']['protocol'] = "udp"
  # CUSTOMIZE - Here change the OSSEC alert
  # level for those alerts to be routed to Slack
  default['ossec']['conf'][type]['integration'] = [
    {
      'name' => 'slack',
      'level' => '9',
      'hook_url' => node['ossec']['hook_url']
    },
    {
      'content!' => {
        'name' => 'pagerduty',
        'level' => '11',
        'api_key' => node['ossec']['pagerduty_key']
     }
   }
  ]
end

default['ossec']['conf']['all']['command'] = [
  {
    'name' => 'host-deny',
    'executable' => 'host-deny.sh',
    'expect' => 'srcip',
    'timeout_allowed' => 'yes'
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
      'name' => 'disable-account',
      'executable' => 'disable-account.sh',
      'expect' => 'user',
      'timeout_allowed' => 'yes'
   }
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
      'name' => 'route-null',
      'executable' => 'disable-account.sh',
      'expect' => 'srcip',
      'timeout_allowed' => 'yes'
    }
  }
]

# CUSTOMIZE - set to true to disable Active Response
default['ossec']['conf']['all']['active-response']['disabled'] = true
default['ossec']['conf']['all']['active-response']['command'] = ['host-deny']
default['ossec']['conf']['all']['active-response']['location'] = ['local']
default['ossec']['conf']['all']['active-response']['level'] = ['6']
default['ossec']['conf']['all']['active-response']['timeout'] = ['1800']

# CUSTOMIZE - may want to add special files
# or directories for changes (for integrity checks)
default['ossec']['conf']['all']['syscheck']['disabled'] = false
default['ossec']['conf']['all']['syscheck']['frequency'] = 43_200
default['ossec']['conf']['all']['syscheck']['scan_on_start'] = true
default['ossec']['conf']['all']['syscheck']['alert_new_files'] = true
default['ossec']['conf']['all']['syscheck']['auto_ignore'] = false
default['ossec']['conf']['all']['syscheck']['directories'] = [
  { '@check_all' => true, 'content!' => '/etc,/usr/bin,/usr/sbin' },
  { '@check_all' => true, 'content!' => '/bin,/sbin,/boot' }
]
default['ossec']['conf']['all']['syscheck']['auto_ignore'] = false
default['ossec']['conf']['all']['syscheck']['ignore'] = [
  '/etc/mtab',
  '/etc/mnttab',
  '/etc/hosts.deny',
  '/etc/mail/statistics',
  '/etc/random-seed',
  '/etc/random.seed',
  '/etc/adjtime',
  '/etc/httpd/logs',
  '/etc/utmpx',
  '/etc/wtmpx',
  '/etc/cups/certs',
  '/etc/dumpdates',
  '/etc/svc/volatile'
]


default['ossec']['conf']['all']['syscheck']['nodiff'] = '/etc/ssl/private.key'
default['ossec']['conf']['all']['syscheck']['skip_nfs'] = true

default['ossec']['conf']['all']['rootcheck']['disabled'] = false
default['ossec']['conf']['all']['rootcheck']['check_unixaudit'] = true
default['ossec']['conf']['all']['rootcheck']['check_files'] = true
default['ossec']['conf']['all']['rootcheck']['check_trojans'] = true
default['ossec']['conf']['all']['rootcheck']['check_dev'] = true
default['ossec']['conf']['all']['rootcheck']['check_sys'] = true
default['ossec']['conf']['all']['rootcheck']['check_pids'] = true
default['ossec']['conf']['all']['rootcheck']['check_ports'] = true
default['ossec']['conf']['all']['rootcheck']['check_if'] = true
default['ossec']['conf']['all']['rootcheck']['frequency'] = 43200
default['ossec']['conf']['all']['rootcheck']['rootkit_files'] = "#{node['ossec']['dir']}/etc/shared/rootkit_files.txt"
default['ossec']['conf']['all']['rootcheck']['rootkit_trojans'] = "#{node['ossec']['dir']}/etc/shared/rootkit_trojans.txt"
default['ossec']['conf']['all']['rootcheck']['system_audit'] = [
  '/var/ossec/etc/shared/system_audit_rcl.txt',
  '/var/ossec/etc/shared/system_audit_ssh.txt'
]
default['ossec']['conf']['all']['rootcheck']['skip_nfs'] = true
# CUSTOMIZE - tailor the log files we would like to monitor.  Also - formart
# must be defined.
default['ossec']['conf']['all']['localfile'] = [
  {
    'log_format' => 'syslog',
    'location' => '/var/log/syslog'
  },
  {
    'content!' => {
      'log_format' => 'syslog',
      'location' => '/var/log/dpkg.log'
    }
  },
  {
    'content!' => {
    'log_format' => 'command',
    'command' => 'df -P',
    'frequency' => 360
     }
  },
  {
    'content!' => {
      'log_format' => 'full_command',
      'command' => 'netstat -tulpen | sort',
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
      'location' => '/var/log/auth.log'
      }
  },
  {
    'content!' => {
      'log_format' => 'syslog',
      'location' => '/var/log/secure'
      }
  },
  {
    'content!' => {
      'log_format' => 'syslog',
      'location' => '/var/log/audit/audit.log'
      }
  },
  {
    'content!' => {
      'log_format' => 'syslog',
      'location' => '/var/log/xferlog'
      }
  },
  {
    'content!' => {
      'log_format' => 'syslog',
      'location' => '/var/log/maillog'
      }
  },
  # CUSTOMIZE - Need proper path for Apache logs
  # (also need to know if there are FTP servers, etc)
  {
    'content!' => {
      'log_format' => 'apache',
      'location' => '/var/www/logs/access_log'
    }
  },
  # CUSTOMIZE - Need proper path for Apache logs
  # (also need to know if there are FTP servers, etc)
  {
    'content!' => {
      'log_format' => 'apache',
      'location' => '/var/www/logs/error_log'
    }
  }
]

default['ossec']['conf']['agent']['client']['server-hostname'] = node['ossec']['hostname_server_ip']

# agent.conf is also populated with Gyoku but in a slightly different
# way. We leave this blank by default because Chef is better at
# distributing agent configuration than OSSEC is.
#
# CUSTOMIZE:
# The following block is commented because
# Chef is responsible for configuring agents
# in the PhishMe environments
#
default['ossec']['agent_conf'] = [
   {
         'syscheck' => { 'frequency' => 7200 },
         'rootcheck' => { 'disabled' => true }
       },
       {
         '@os' => 'Windows',
         'content!' => {
           'syscheck' => { 'frequency' => 7200 }
         }
       }
 ]
