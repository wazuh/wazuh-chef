default['filebeat']['config_path'] = '/etc/filebeat/filebeat.yml'
default['filebeat']['wazuh_filebeat_module'] = "wazuh-filebeat-0.1.tar.gz"
default['filebeat']['wazuh_template'] = "wazuh-template.json"
default['filebeat']['yml'] = {
	'output_elasticsearch_hosts' => {
		"0.0.0.0": 9200
	},
	'output_elasticsearch_protocol' => "https",
	'output_elasticsearch_username' => "\"admin\"",
	'output_elasticsearch_password' => "\"admin\"",
	'ssl_certificate_authorities' => "/etc/filebeat/certs/root-ca.pem",
	'ssl_certificate' => "\"/etc/filebeat/certs/filebeat.pem\"",
	'ssl_key' => "\"/etc/filebeat/certs/filebeat.key\"",
	'setup_template_json_enabled' => true,
	'setup_template_json_path' => "\'/etc/filebeat/#{node['filebeat']['wazuh_template']}\'",
	'setup_template_json_name' => "\'wazuh\'",
	'setup_ilm_overwrite' => true,
	'setup_ilm_enabled' => false,
	'filebeat_modules_module' => "wazuh",
	'filebeat_modules_alerts_enabled' => true,
	'filebeat_modules_archives_enabled' => false
}