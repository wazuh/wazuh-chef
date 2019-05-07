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
default['ossec']['address'] = nil
default['ossec']['ignore_failure'] = true

# Commands settings
default['ossec']['conf']['server']['command'] = [
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

# Agent settings (agent)
default['ossec']['conf']['agent']['client']['server']['address'] = node['ossec']['address']
default['ossec']['conf']['agent']['client']['server']['port'] = 1514
default['ossec']['conf']['agent']['client']['server']['protocol'] = 'udp'
default['ossec']['conf']['agent']['client']['notify_time'] = 10
default['ossec']['conf']['agent']['client']['time-reconnect'] = 60
default['ossec']['conf']['agent']['client']['auto_restart'] = true

default['ossec']['conf']['server']['auth']['port'] = 1515


default['ossec']['conf']['agent']['client_buffer']['disable'] = false
default['ossec']['conf']['agent']['client_buffer']['queue_size'] = 5000
default['ossec']['conf']['agent']['client_buffer']['events_per_second'] = 500

default['ossec']['conf']['agent']['active-response']['disabled'] = false
default['ossec']['conf']['agent']['active-response']['ca_store'] = '/var/ossec/etc/wpk_root.pem'


# Syscheck settings
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


# Rootcheck settings
default['ossec']['conf']['all']['rootcheck']['disabled'] = true
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
case node['platform_family']
when 'debian'
  default['ossec']['conf']['all']['rootcheck']['system_audit'] = [
    '/var/ossec/etc/shared/system_audit_rcl.txt',
    '/var/ossec/etc/shared/system_audit_ssh.txt',
    '/var/ossec/etc/shared/cis_debian_linux_rcl.txt'
  ]
when 'rhel'
  if node['platform_version'].to_i == 5
    default['ossec']['conf']['all']['rootcheck']['system_audit'] = [
      '/var/ossec/etc/shared/system_audit_rcl.txt',
      '/var/ossec/etc/shared/system_audit_ssh.txt',
      '/var/ossec/etc/shared/cis_rhel5_linux_rcl.txt'
    ]
  end
  if node['platform_version'].to_i == 6
    default['ossec']['conf']['all']['rootcheck']['system_audit'] = [
      '/var/ossec/etc/shared/system_audit_rcl.txt',
      '/var/ossec/etc/shared/system_audit_ssh.txt',
      '/var/ossec/etc/shared/cis_rhel6_linux_rcl.txt'
    ]
  end
  if node['platform_version'].to_i == 7
    default['ossec']['conf']['all']['rootcheck']['system_audit'] = [
      '/var/ossec/etc/shared/system_audit_rcl.txt',
      '/var/ossec/etc/shared/system_audit_ssh.txt',
      '/var/ossec/etc/shared/cis_rhel7_linux_rcl.txt'
    ]
  end
end

default['ossec']['conf']['all']['rootcheck']['skip_nfs'] = true

# Localfiles settings
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
  {
    'content!' => {
      'log_format' => 'apache',
      'location' => '/var/www/logs/access_log'
    }
  },
  {
    'content!' => {
      'log_format' => 'apache',
      'location' => '/var/www/logs/error_log'
    }
  }
]
