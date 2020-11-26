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
default['wazuh-elastic']['kibana_wazuh_api_credentials'] = [ { id: "default", url: "https://localhost", port: "55000", username: "wazuh", password: "wazuh" } ]