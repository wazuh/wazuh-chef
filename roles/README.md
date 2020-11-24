Wazuh roles
====================================

# Attrributes

Manager
------------

### How to bind a specific IP address to manager?

In case you have a non single-node installation and want to bind a specifi IP address to the manager 
the followig attributes must be override:

* ```node['api]['ip']```: the IP address bind to the API
* ```node['api]['port']```: the port bind to the API

Filebeat
------------

* ```node['filebeat']['elastic_nodes']```: array with all Elastic nodes IP and port (<IP>:<PORT>)