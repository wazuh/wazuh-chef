# Syscheck settings
default['ossec']['conf']['syscheck']['disabled'] = false
default['ossec']['conf']['syscheck']['frequency'] = 43200
default['ossec']['conf']['syscheck']['scan_on_start'] = true
default['ossec']['conf']['syscheck']['ignore'] = [
    '/etc/mtab',
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
    '/etc/svc/volatile',
    '/sys/kernel/security',
    '/sys/kernel/debug',
    '/dev/core',
    { '@type' => 'sregex', 'content!' => '^/proc' },
    { '@type' => 'sregex', 'content!' => '.log$|.swp$'}
]

default['ossec']['conf']['syscheck']['directories'] = [
  { '@check_all' => true, 'content!' => '/etc,/usr/bin,/usr/sbin' },
  { '@check_all' => true, 'content!' => '/bin,/sbin,/boot' }
]

default['ossec']['conf']['syscheck']['nodiff'] = '/etc/ssl/private.key'
default['ossec']['conf']['syscheck']['skip_nfs'] = true

=begin
# Syscheck settings
default['ossec']['conf']['syscheck'] = [{
  'disabled' => 'no',
  'frequency' => '43200',
  'scan_on_start' => 'yes',
  ['ignore'] = [
    '/etc/mtab',
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
    '/etc/svc/volatile',
    '/sys/kernel/security',
    '/sys/kernel/debug',
    '/dev/core',
    { '@type' => 'sregex', 'content!' => '^/proc' },
    { '@type' => 'sregex', 'content!' => '.log$|.swp$'}
  ],
  ['directories'] = [
    { '@check_all' => true, 'content!' => '/etc,/usr/bin,/usr/sbin' },
    { '@check_all' => true, 'content!' => '/bin,/sbin,/boot' }
  ],
  'nodiff' => '/etc/ssl/private.key',
  'skip_nfs' => 'yes'
}]
=end