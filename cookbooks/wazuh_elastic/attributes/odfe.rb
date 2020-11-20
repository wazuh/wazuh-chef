# elasticsearch.yml configuration file
default['odfe']['yml'] = {
    'network' => {
        'host' => node['wazuh-elastic']['ip']
    },
    'node' => {
        'name' => "node-1",
        'max_local_storage_nodes' => 3
    },
    'cluster' => {
        'initial_master_nodes' => "node-1",
        'routing' => {
            'allocation' => {
                'disk' => {
                    'threshold_enabled' => false
                }
            }
        }
    },
    'path' => {
        'data' => "/var/lib/elasticsearch",
        'logs' => "/var/log/elasticsearch"
    },
    'opendistro_security' => {
        'ssl' => {
            'transport' => {
                'pemcert_filepath' => "/etc/elasticsearch/certs/elasticsearch.pem",
                'pemkey_filepath' => "/etc/elasticsearch/certs/elasticsearch.key",
                'pemtrustedcas_filepath' => "/etc/elasticsearch/certs/root-ca.pem",
                'enforce_hostname_verification' => false,
                'resolve_hostname' => false
            },
            'http' => {
                'enabled' => true,
                'pemcert_filepath' => "/etc/elasticsearch/certs/elasticsearch_http.pem",
                'pemkey_filepath' => "/etc/elasticsearch/certs/elasticsearch_http.key",
                'pemtrustedcas_filepath' => "/etc/elasticsearch/certs/root-ca.pem"    
            }
        },
        'nodes_dn' => [
            "CN=node-1,OU=Docu,O=Wazuh,L=California,C=US"
        ],
        'authcz' => {
            'admin_dn' => [
                "CN=admin,OU=Docu,O=Wazuh,L=California,C=US"
            ]
        },
        'audit' => {
            'type' => "internal_elasticsearch"
        },
        'enable_snapshot_restore_privilege' => true,
        'check_snapshot_restore_write_privileges' => true,
        'restapi' => {
            'roles_enabled' => [
                "all_access",
                "security_rest_api_access"
            ]
        }
    }
}
