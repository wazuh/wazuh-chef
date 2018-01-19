# filebeat

## Description
Cookbook with LWRPs for install and managing [filebeat](https://github.com/elastic/beats)

### filebeat
Adds information about wich files must be forwarded to remote logstash server to config file.


#### Platforms
Tested on Ubuntu and CentOS, but should work on any Unix/Linux platform supported by Wazuh. Installation by default is done from packages.

This cookbook doesn't configure Windows systems yet. For information on installing Wazuh on Windows, see the [free chapter](https://documentation.wazuh.com/current/installation-guide/installing-wazuh-agent/wazuh_agent_windows.html)

#### Chef
- Chef 12+

#### Cookbooks
- apt
- yum

Attributes
----------

default['filebeat']['package_name'] = 'filebeat'
default['filebeat']['service_name'] = 'filebeat'
default['filebeat']['logstash_servers'] = 'indexer.wazuh.com:5000'
default['filebeat']['timeout'] = 15
default['filebeat']['config_path'] = '/etc/filebeat/filebeat.yml'
default['filebeat']['ssl_ca'] = '/etc/filebeat/logstash_certificate.crt'


* `node['filebeat']['package_name']` - Package name
* `node['filebeat']['service_name']` - Service name
* `node['filebeat']['logstash_servers'] ` - Logstash server IP or hostname
* `node['filebeat']['timeout'] ` - Seconds until the timeout
* `node['filebeat']['config_path'] ` - Certificate path.
* `node['filebeat']['ssl_ca'] ` - SSL path.

Recipes
-------

### default

This recipe includes the recipe wazuh_filebeat::repository and wazuh_filebeat::filebeat

### repository

Installs Elastics repository.


### filebeat

Install the package Filebeats, create the configuration through a template in /etc/filebeat/filebeat.yml




* [Wazuh Documentation](https://documentation.wazuh.com/current/installation-guide/installing-wazuh-server/wazuh_server_rpm.html#installing-filebeat)
