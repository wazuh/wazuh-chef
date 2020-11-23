default["filebeat"]["config_path"] = "/etc/filebeat"
default["filebeat"]["wazuh_filebeat_module"] = "wazuh-filebeat-0.1.tar.gz"
default["filebeat"]["wazuh_template"] = "wazuh-template.json"
# Array with Elastic nodes IP
default["filebeat"]["elastic_nodes_ip"] = [
	"\"0.0.0.0:9200\""
]
default["filebeat"]["yml"] = {
	"output": {
		"elasticsearch": {
			"hosts": node["filebeat"]["elastic_nodes_ip"],
			"protocol": "https",
			"username": "\"admin\"",
			"password": "\"admin\"",
			"ssl": {
				"certificate_authorities": [
					"/etc/filebeat/certs/root-ca.pem"
				],
				"certificate": "/etc/filebeat/certs/filebeat.pem",
				"key": "/etc/filebeat/certs/filebeat.key"
			}
		}
	},
	"setup": {
		"template": {
			"json": {
				"enabled": true,
				"path": "/etc/filebeat/wazuh-template.json",
				"name": "\"wazuh\""
			}
		},
		"ilm": {
			"overwrite": true,
			"enabled": false
		}
	},
	"filebeat": [
		{
			"module": "wazuh",
			"alerts": {
				"enabled": true
			},
			"archives": {
				"enabled": false
			}
		}
	]
}