# Elasticsearch configuration file
default['elastic']['yml'] = {
    'cluster' => {
        'name' => 'es-wazuh',
        'initial_master_nodes' => [
            'es-node-01'
        ]
    },
    'node' => {
        'name' => 'es-node-01'
    },
    'path' => {
        'data' => "/var/lib/elasticsearch",
        'logs' => "/var/log/elasticsearch"
    },
    'network' => {
        'host' => '0.0.0.0'
    },
    'http' => {
        'port' => 9200
    }
}

# Kibana configuration file
default['kibana']['yml'] = {
    'server' => {
        'host' => '0.0.0.0',
        'port' => 443
    },
    'elasticsearch' => {
        'hosts' => [
            "https://#{node['elastic']['yml']['network']['host']}:#{node['elastic']['yml']['http']['port']}"
        ]
    }
}
