
default['ossec']['conf']['client']['server']['address'] = node['ossec']['address']
default['ossec']['conf']['client']['server']['port'] = 1514
default['ossec']['conf']['client']['server']['protocol'] = 'udp'
default['ossec']['conf']['client']['notify_time'] = 10
default['ossec']['conf']['client']['time-reconnect'] = 60
default['ossec']['conf']['client']['auto_restart'] = true
default['ossec']['conf']['client']['crypto_method'] = "aes"