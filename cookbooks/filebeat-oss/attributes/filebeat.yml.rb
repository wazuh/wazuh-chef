# Cookbook Name:: filebeat-oss
# Attribute:: filebeat.yml
# Author:: Wazuh <info@wazuh.com>

default['filebeat']['yml'] = {
    'output' => {
        'elasticsearch' => {
            'hosts' => [
                {
                    'ip' => "#{node['network']['elasticsearch']['ip']}",
                    'port' => "#{node['network']['elasticsearch']['port']}"
                }
            ]
        }
    }
}


