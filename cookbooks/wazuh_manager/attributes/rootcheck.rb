# Rootcheck settings
default['ossec']['conf']['rootcheck'] = {
    'disabled' => false,
    'check_files' => true,
    'check_trojans' => true,
    'check_dev' => true,
    'check_sys' => true,
    'check_pids' => true,
    'check_ports' => true,
    'check_if' => true,
    'frequency' => 43200,
    'rootkit_files' => "#{node['ossec']['dir']}/etc/rootcheck/rootkit_files.txt",
    'rootkit_trojans' => "#{node['ossec']['dir']}/etc/rootcheck/rootkit_trojans.txt",
    'skip_nfs' => true
}
