# Filebeat cookbook

## Description
This cookbook installs and configures Filebeat in order on the specified node. It's important to mention that he ```logstash_servers``` attribute is obligatory and defines the Logstash IP's

#### Chef
- Chef 12+

#### Cookbooks
- apt
- yum

Attributes
----------

Default configuration is defined in ```/attributes/default.rb``` and contains needed parameters to configure the ```filebeat.yml``` file. Check ['Filebeat section'](https://raw.githubusercontent.com/wazuh/wazuh/3.9/extensions/filebeat/filebeat.yml) to see an example of Filebeat configuration.

## Installation

Create a role, wazuh_filebeat. Add attributes per above as needed to customize the installation.



```
  {
    "name": "wazuh_filebeat",
    "description": "Wazuh Manager host",
    "json_class": "Chef::Role",
    "default_attributes": {

    },
    "override_attributes": {
        "filebeat": {
            "logstash_servers" : "<YOUR LOGSTASHs IPs HERE>"
            
        }

    },
    "chef_type": "role",
    "run_list": [
      "recipe[wazuh_filebeat::filebeat]"
    ],
    "env_run_lists": {

    }
  }
```

Default attributes are: 

* `node['filebeat']['package_name']` - Package name
* `node['filebeat']['service_name']` - Service name
* `node['filebeat']['logstash_servers'] ` - Logstash server IP or hostname
* `node['filebeat']['timeout'] ` - Seconds until the timeout
* `node['filebeat']['config_path'] ` - Certificate path.
* `node['filebeat']['ssl_ca'] ` - SSL path.

Recipes
-------

#### default.rb

This recipe imports and executes the recipe *wazuh_filebeat::repository* and *wazuh_filebeat::filebeat*

#### repository.rb

Installs Filebeat repository and creates the */etc/apt/sources.list.d/elastic-6.x.list* file.

#### filebeat.rb

Install the package Filebeats, create the configuration of */etc/filebeat/filebeat.yml* with defined attributes in the ```attributes``` folder.

## References

Check [Wazuh Filebeat Documentation](https://documentation.wazuh.com/current/installation-guide/installing-wazuh-server/wazuh_server_rpm.html#installing-filebeat) for more information about Wazuh and Filebeat.