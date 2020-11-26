# Syscheck settings
default['ossec']['conf']['syscheck'] = {
  'disabled' => false,
  'frequency' => '43200',
  'scan_on_start' => true,
  'alert_new_files' => true,
  'auto_ignore' => {
    '@frequency' => '10', 
    '@timeframe' => '3600', 
    'content!' => false 
  }, 
  'directories' => [
    { '@check_all' => true, 'content!' => '/etc,/usr/bin,/usr/sbin' },
    { '@check_all' => true, 'content!' => '/bin,/sbin,/boot' }
  ],
  'ignore' => [
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
  'nodiff' => '/etc/ssl/private.key',
  'skip_nfs' => true,
  'skip_dev' => true,
  'skip_proc' => true,
  'skip_sys' => true,
  'max_eps' => '100',
  'process_priority' => '10',
  'synchronization' => {
    'enabled' => true,
    'interval' => '5m',
    'max_interval' => '1h',
    'max_eps' => '10'
  }
}