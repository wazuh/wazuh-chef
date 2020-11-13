# <client> ... </client> ossec.conf variables

# <client>
#   <server> 
#       ... 
#   </server> 
# </client> 

default['ossec']['conf']['client']['server'] = [{
        'address' => node['ossec']['address'],
        'port' => "1514",
        'protocol' => "tcp",
        'max_retries' => "5",
        'retry_interval' => "5"
}]

# <client>
#   ...
# </client>

default['ossec']['conf']['client'] = [{
    # 'config-profile' => ""    
    'notify_time' => "10",
    'time-reconnect' => "60",
    # 'local_ip' => "",
    'disable-active-response' => "no",
    'auto_restart' => "yes",
    'crypto_method' => "aes"
}]                                

# <client>
#   <enrollment> 
#       ... 
#   </enrollment> 
# </client> 

default['ossec']['conf']['client']['enrollment'] = [{
    'enabled' => "yes",
    # 'manager_address' => "",
    'port' => "1515",
    # 'agent_name' => "",
    # 'groups' => "",
    # 'agent_address' => "",
    'ssl_cipher' => "HIGH:!ADH:!EXP:!MD5:!RC4:!3DES:!CAMELLIA:@STRENGTH",
    # 'server_ca_path' => "",
    # 'agent_certificate_path' => "", 
    # 'agent_key_path' => "",
    # 'authorization_pass_path' => "",
    'auto_method' => "no",
    'delay_after_enrollment' => "20",
    'use_source_ip' => "no"
}]
