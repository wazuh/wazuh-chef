# Registration service - Authd settings (Manager)
default['ossec']['conf']['auth']['disabled'] = false
default['ossec']['conf']['auth']['port'] = 1515
default['ossec']['conf']['auth']['use_source_ip'] = true
default['ossec']['conf']['auth']['force_insert'] = true
default['ossec']['conf']['auth']['force_time'] = 0
default['ossec']['conf']['auth']['purge'] = true
default['ossec']['conf']['auth']['use_password'] = false
default['ossec']['conf']['auth']['ciphers'] = 'HIGH:!ADH:!EXP:!MD5:!RC4:!3DES:!CAMELLIA:@STRENGTH'
default['ossec']['conf']['auth']['ssl_verify_host'] = false
default['ossec']['conf']['auth']['ssl_manager_cert'] = "#{node['ossec']['dir']}/etc/sslmanager.cert"
default['ossec']['conf']['auth']['ssl_manager_key'] = "#{node['ossec']['dir']}/etc/sslmanager.key"
default['ossec']['conf']['auth']['ssl_auto_negotiate'] = false