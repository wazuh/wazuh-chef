# Filebeat cookbook

## Description
This cookbook installs and configures Filebeat in order on the specified node.

Attributes
----------

Default configuration is defined in ```/attributes/default.rb``` and contains needed parameters to configure the ```filebeat.yml``` file. 

Important attributes: 

* ```node['filebeat']['yml']['output']['elasticsearch']['hosts']```: array elasticsearch nodes network
parameters (ip and port)


## Installation

Create a role, wazuh_filebeat. Add attributes per above as needed to customize the installation.

```
  {
    "name": "filebeat",
    "description": "Filebeat host",
    "json_class": "Chef::Role",
    "default_attributes": {

    },
    "override_attributes": {
        
    },
    "chef_type": "role",
    "run_list": [
      "recipe[filebeat::default]"
    ],
    "env_run_lists": {

    }
  }
```

Recipes
-------

#### default.rb

This recipe imports and executes the following recipes:
* *repository*
* *filebeat*

#### repository.rb

Append to repository path the URL and GPG key of Filebeat

#### filebeat.rb

* Install the package Filebeats
* Create the configuration of */etc/filebeat/filebeat.yml* with defined attributes in the ```attributes``` folder
* Download the alerts template for Elasticsearch
* Download the Wazuh module for Filebeat

## References

Check [Filebeat installation documentation](https://documentation.wazuh.com/4.0/learning-wazuh/build-lab/install-wazuh-manager.html#install-filebeat) for more detail