default["filebeat"] = {
	"config_path" => "/etc/filebeat",
	"wazuh_filebeat_module" => "wazuh-filebeat-0.1.tar.gz",
	"wazuh_template" => "wazuh-template.json",
	# Array with Elastic nodes IP
	"elastic_nodes" => [
		"0.0.0.0:9200"
	]
}