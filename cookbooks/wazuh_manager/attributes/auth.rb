# Cookbook Name:: wazuh-manager
# Attributes:: auth
# Author:: Wazuh <info@wazuh.com

# Registration service - Authd settings (Manager)
default['ossec']['conf']['auth'] = {
    'disabled' => false,
    'port' => 1515,
    'use_source_ip' => false,
    'purge' => true,
    'use_password' => false,
    'limit_maxagents' => true,
    'ciphers' => 'HIGH:!ADH:!EXP:!MD5:!RC4:!3DES:!CAMELLIA:@STRENGTH',
    'ssl_verify_host' => false,
    'ssl_manager_cert' => "#{node['ossec']['dir']}/etc/sslmanager.cert",
    'ssl_manager_key' => "#{node['ossec']['dir']}/etc/sslmanager.key",
    'ssl_auto_negotiate' => false
    'force' => {
        'enabled' => "yes"
        'key_mismatch' => "yes"
        'disconnected_time' => "1hs"
        'after_registration_time' => "1hs"
    },
}