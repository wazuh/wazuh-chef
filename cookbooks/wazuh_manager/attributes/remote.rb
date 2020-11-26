# Remoted settings
default['ossec']['conf']['remote'] = {
    'connection' => 'secure',
    'port' => "1514",
    'protocol' => "tcp",
    'queue_size' => "131072"
}