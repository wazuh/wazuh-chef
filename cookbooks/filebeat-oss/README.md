# Filebeat OSS cookbook

This cookbook installs and configures Filebeat OSS on the specified node.

## Attributes

* `files.rb`: initialize needed file names to install Filebeat
* `paths.rb`: initialize some main paths
* `versions.rb`: initialize versions for Wazuh and ELK
* `yml.rb`: customize *filebeat.yml* configuration file 

## Usage

See `wazuh-manager` cookbook documentation.

## Recipes

### default.rb

Declares all recipes in the cookbook and installs Filebeat.

#### repository.rb

Append to repository path the URL and GPG key of Filebeat

#### filebeat.rb

* Install the package Filebeats OSS
* Create the configuration of */etc/filebeat/filebeat.yml* with defined attributes in the ```attributes``` folder
* Download the alerts template for Elasticsearch
* Download the Wazuh module for Filebeat

## References

Check [Filebeat installation documentation](https://documentation.wazuh.com/current/learning-wazuh/build-lab/install-wazuh-manager.html#install-filebeat) for more detail