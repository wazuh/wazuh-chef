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
default['ossec']['address'] = nil
default['ossec']['ignore_failure'] = true

# Commands settings
default['ossec']['conf']['command'] = [
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
default['ossec']['conf']['client']['server']['address'] = node['ossec']['address']
default['ossec']['conf']['client']['server']['port'] = 1514
default['ossec']['conf']['client']['server']['protocol'] = 'udp'
default['ossec']['conf']['client']['notify_time'] = 10
default['ossec']['conf']['client']['time-reconnect'] = 60
default['ossec']['conf']['client']['auto_restart'] = true

default['ossec']['conf']['auth']['port'] = 1515


default['ossec']['conf']['client_buffer']['disable'] = false
default['ossec']['conf']['client_buffer']['queue_size'] = 5000
default['ossec']['conf']['client_buffer']['events_per_second'] = 500

default['ossec']['conf']['active-response']['disabled'] = false
default['ossec']['conf']['active-response']['ca_store'] = '/var/ossec/etc/wpk_root.pem'


# Syscheck settings
default['ossec']['conf']['syscheck']['disabled'] = false
default['ossec']['conf']['syscheck']['frequency'] = 43_200
default['ossec']['conf']['syscheck']['scan_on_start'] = true
default['ossec']['conf']['syscheck']['alert_new_files'] = true
default['ossec']['conf']['syscheck']['auto_ignore'] = false
default['ossec']['conf']['syscheck']['directories'] = [
  { '@check_all' => true, 'content!' => '/etc,/usr/bin,/usr/sbin' },
  { '@check_all' => true, 'content!' => '/bin,/sbin,/boot' }
]
default['ossec']['conf']['syscheck']['ignore'] = [
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


default['ossec']['conf']['syscheck']['nodiff'] = '/etc/ssl/private.key'
default['ossec']['conf']['syscheck']['skip_nfs'] = true


# Rootcheck settings
default['ossec']['conf']['rootcheck']['disabled'] = true
default['ossec']['conf']['rootcheck']['check_files'] = true
default['ossec']['conf']['rootcheck']['check_trojans'] = true
default['ossec']['conf']['rootcheck']['check_dev'] = true
default['ossec']['conf']['rootcheck']['check_sys'] = true
default['ossec']['conf']['rootcheck']['check_pids'] = true
default['ossec']['conf']['rootcheck']['check_ports'] = true
default['ossec']['conf']['rootcheck']['check_if'] = true
default['ossec']['conf']['rootcheck']['frequency'] = 43200
default['ossec']['conf']['rootcheck']['rootkit_files'] = "#{node['ossec']['dir']}/etc/rootcheck/rootkit_files.txt"
default['ossec']['conf']['rootcheck']['rootkit_trojans'] = "#{node['ossec']['dir']}/etc/rootcheck/rootkit_trojans.txt"
default['ossec']['conf']['rootcheck']['skip_nfs'] = true

# Localfiles settings
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

