# Filebeat cookbook

## Description
This cookbook installs and configures Filebeat in order on the specified node.

#### Chef
- Chef 12+

#### Cookbooks
- apt
- yum
- zypper

Attributes
----------

Default configuration is defined in ```/attributes/default.rb``` and contains needed parameters to configure the ```filebeat.yml``` file. Check ['Filebeat section'](https://raw.githubusercontent.com/wazuh/wazuh/v4.0.2/extensions/filebeat/7.x/filebeat.yml) to see an example of Filebeat configuration.

Important attributes: 

* ```node['filebeat']['elasticsearch_server_ip']```: array with URL of elasticsearch nodes

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


Recipes
-------

#### default.rb

This recipe imports and executes the recipe *wazuh_filebeat::filebeat*

#### repository.rb

Append to repository path the URL and GPG key of Filebeat

#### filebeat.rb

* Install the package Filebeats
* Create the configuration of */etc/filebeat/filebeat.yml* with defined attributes in the ```attributes``` folder
* Download the alerts template for Elasticsearch
* Download the Wazuh module for Filebeat

## References

Check [Filebeat installation documentation](https://documentation.wazuh.com/4.0/learning-wazuh/build-lab/install-wazuh-manager.html#install-filebeat) for more detail