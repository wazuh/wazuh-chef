# Rootcheck settings
default['ossec']['conf']['rootcheck'] = [{
    'disabled' => 'no',
    'check_files' => 'yes',
    'check_trojans' => 'yes',
    'check_dev' => 'yes',
    'check_sys' => 'yes',
    'check_pids' => 'yes',
    'check_ports' => 'yes',
    'check_if' => 'yes',
    'frequency' => '43200',
    'rootkit_files' => "#{node['ossec']['dir']}/etc/shared/rootkit_files.txt",
    'rootkit_trojans' => "#{node['ossec']['dir']}/etc/shared/rootkit_trojans.txt",
    'skip_nfs' => 'yes'    
}]
