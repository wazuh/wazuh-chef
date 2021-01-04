# Cookbook Name:: filebeat
# Attribute:: filebeat.yml
# Author:: Wazuh <info@wazuh.com>

default['filebeat']['yml'] = {
    'output' => {
        'elasticsearch' => {
            'hosts' => [
                {
                    'ip' => '0.0.0.0',
                    'port' => 9200
                }
            ]
        }
    }
}

