# Cookbook Name:: filebeat
# Attribute:: elastic
# Author:: Wazuh <info@wazuh.com>

default['filebeat']['yml'] = [
    'output' => {
        'elasticsearch' => {
            'hosts' => [
                "http://0.0.0.0:9200"
            ]
        }
    }
]


