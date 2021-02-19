# Cookbook Name:: filebeat
# Attribute:: filebeat.yml
# Author:: Wazuh <info@wazuh.com>

default['filebeat']['yml'] = {
    'elasticsearch' => {
        'ip' => "#{node['network']['elasticsearch']['ip']}",
        'port' => "#{node['network']['elasticsearch']['port']}",
        'password' => "#{node['network']['elasticsearch']['password']}"
    }
}
