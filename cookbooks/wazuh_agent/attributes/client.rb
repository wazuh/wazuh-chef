# <client> ... </client> ossec.conf variables

# Server subsection <server> ... </server> 

default['ossec']['conf']['client']['server']['address'] = node['ossec']['address']
default['ossec']['conf']['client']['server']['port'] = 1514
default['ossec']['conf']['client']['server']['protocol'] = 'udp'
default['ossec']['conf']['client']['server']['max_retries'] = '5'
default['ossec']['conf']['client']['server']['retry_interval'] = '5'

# Client subvariables

default['ossec']['conf']['client']['config-profile'] = nil
default['ossec']['conf']['client']['notify_time'] = 10
default['ossec']['conf']['client']['time-reconnect'] = 60
default['ossec']['conf']['client']['local_ip'] = nil
default['ossec']['conf']['client']['disable-active-response'] = false
default['ossec']['conf']['client']['auto_restart'] = true
default['ossec']['conf']['client']['crypto_method'] = "aes"

# Enrollment subsection <enrollment> ... </enrollment>

default['ossec']['conf']['client']['enrollment']['enabled'] = true
default['ossec']['conf']['client']['enrollment']['manager_address'] = nil
default['ossec']['conf']['client']['enrollment']['port'] = 1515
default['ossec']['conf']['client']['enrollment']['agent_name'] = nil
default['ossec']['conf']['client']['enrollment']['groups'] = nil
default['ossec']['conf']['client']['enrollment']['agent_address'] = nil
default['ossec']['conf']['client']['enrollment']['ssl_cipher'] = "HIGH:!ADH:!EXP:!MD5:!RC4:!3DES:!CAMELLIA:@STRENGTH"
default['ossec']['conf']['client']['enrollment']['server_ca_path'] = nil
default['ossec']['conf']['client']['enrollment']['agent_certificate_path'] = nil 
default['ossec']['conf']['client']['enrollment']['agent_key_path'] = nil
default['ossec']['conf']['client']['enrollment']['authorization_pass_path'] = nil
default['ossec']['conf']['client']['enrollment']['auto_method'] = false
default['ossec']['conf']['client']['enrollment']['delay_after_enrollment'] = 20
default['ossec']['conf']['client']['enrollment']['use_source_ip'] = false