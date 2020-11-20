default['search_guard']['tls_tool'] = "search-guard-tlstool-1.8.zip"
default['search_guard']['config_path'] = "/etc/searchguard"
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