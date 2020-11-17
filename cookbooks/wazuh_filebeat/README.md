# Filebeat cookbook

## Description
This cookbook installs and configures Filebeat in order on the specified node.

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
* `node['filebeat']['timeout'] ` - Seconds until the timeout
* `node['filebeat']['config_path'] ` - Certificate path.
* `node['filebeat']['ssl_ca'] ` - SSL path.

Recipes
-------

#### default.rb

This recipe imports and executes the recipe *wazuh_filebeat::filebeat*

#### filebeat.rb

Install the package Filebeats, create the configuration of */etc/filebeat/filebeat.yml* with defined attributes in the ```attributes``` folder.

## References

Check [Wazuh Filebeat Documentation](https://documentation.wazuh.com/4.0/installation-guide/open-distro/distributed-deployment/step-by-step-installation/wazuh-cluster/wazuh_single_node_cluster.html#installing-filebeat) for more information about Wazuh and Filebeat.