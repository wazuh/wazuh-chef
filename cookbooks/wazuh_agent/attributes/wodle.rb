default['ossec']['conf']['wodle'] = [
     {   '@name' => 'cis-cat',
        'disabled' => 'yes',
        'timeout' => '1800',
        'interval' => '1d',
        'scan-on-start' => 'yes',
        'java_path' => 'wodles/java',
        'ciscat_path' => 'wodles/ciscat'
     },
     {   '@name' => 'osquery',
        'disabled' => 'yes',
        'run_daemon' => 'yes',
        'log_path' => '/var/log/osquery/osqueryd.results.log',
        'config_path' => '/etc/osquery/osquery.conf',
        'add_labels' => 'yes'
     },
     {   '@name' => 'syscollector',
        'disabled' => 'no',
        'interval' => '1d',
        'scan_on_start' => 'yes',
        'hardware' => 'yes',
        'os' => 'yes',
        'network' => 'yes',
        'packages' => 'yes',
        'ports' => { '@all' => 'no', 'content!' => 'yes'},
        'processes' => 'yes'
     }
]
