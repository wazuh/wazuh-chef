
default['ossec']['conf']['sca']['enabled'] = true
default['ossec']['conf']['sca']['scan_on_start'] = true
default['ossec']['conf']['sca']['interval'] = "12h"
default['ossec']['conf']['sca']['skip_nfs'] = true
default['ossec']['conf']['sca']['policies']['policy'] = [ 'cis_debian_linux_rcl.yml', 'system_audit_rcl.yml', 'system_audit_ssh.yml', 'system_audit_pw.yml']
