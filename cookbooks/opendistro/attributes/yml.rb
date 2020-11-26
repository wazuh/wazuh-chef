# Elasticsearch-oss configuration file

default['elastic']['yml'] = {
    'network' => {
        'host' => '0.0.0.0'
    },
    'node' => {
        'name' => "odfe-node-1"
    },
    'cluster' => {
        'initial_master_nodes' => "#{node['elastic']['yml']['node']['name']}"
    }
}

# Kibana-oss configuration file

default['kibana']['yml'] = {
    'server' => {
        'host' => '0.0.0.0',
        'port' => 5601
    },
    'elasticsearch' => {
        'hosts' => [
            "https://#{node['wazuh-elastic']['yml']['network']['host']}:#{node['wazuh-elastic']['yml']['http']['port']}"
        ]
    }
}

# Searchguard configuraion file

default['search_guard']['yml'] = 
{
    "ca" => {
        "root" => {
            "dn" => "CN=elasticsearch,OU=Docu,O=Wazuh,L=California,C=US",
            "keysize" => 2048,
            "validityDays" => 3650,
            "pkPassword" => "none",
            "file" => "root-ca.pem"
        }
    },
    "defaults" => {
        "validityDays" => 3650,
        "pkPassword" => "none",
        "generatedPasswordLength" => 12,
        "httpsEnabled" => true
    },
    "nodes" => [
        {
            "name" => "elasticsearch",
            "dn" => "CN=node-1,OU=Docu,O=Wazuh,L=California,C=US",
            "ip" => [
                "#{node['wazuh-elastic']['ip']}"
            ]
        },
        {
            "name" => "kibana",
            "dn" => "CN=kibana,OU=Docu,O=Wazuh,L=California,C=US",
            "ip" => [
                "#{node['wazuh-kibana']['ip']}"
            ]
        }
    ],
    "clients" => [
        {
            "name" => "admin",
            "dn" => "CN=admin,OU=Docu,O=Wazuh,L=California,C=US",
            "admin" => true
        },
        {
            "name" => "filebeat",
            "dn" => "CN=filebeat,OU=Docu,O=Wazuh,L=California,C=US"
        }
    ]
}