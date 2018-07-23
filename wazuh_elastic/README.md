Elastic Stack cookbook
=======================

Installs Elastic Stack. See:

https://documentation.wazuh.com/

Requirements
------------
#### Platforms
Tested on Ubuntu and CentOS, but should work on any Unix/Linux platform supported by Wazuh. Installation by default is done from packages.

This cookbook doesn't configure Windows systems yet. For information on installing Wazuh on Windows, see the [documentation](https://documentation.wazuh.com/current/installation-guide/installing-elastic-stack/index.htmll)

#### Chef
- Chef 12.14+

#### Cookbooks
- apt
- chef-sugar
- poise-python
- hostsfile

Attributes
----------

* `node['wazuh-elastic']['elasticsearch_cluster_name']` - Defines the cluster name.
* `node['wazuh-elastic']['elasticsearch_node_name']` - Defines the elasticsearch node name.
* `nose['wazuh-elastic']['elasticsearch_port']` - Defines the elasticsearch port.
* `node['wazuh-elastic']['elasticsearch_ip'] = 'localhost' - Defines the elasticsearch ip.

* `node['wazuh-elastic']['kibana_host']` - This setting specifies the IP address of the back end server..
* `node['wazuh-elastic']['kibana_port']` - Kibana is served by a back end server. This setting specifies the port to use.
* `node['wazuh-elastic']['kibana_elasticsearch_server']` - The URL of the Elasticsearch instance to use for all your queries.


Recipes
-------

### Deault

Includes all recipe to install the full Elastic Stack in the same server

### repository

We add the differents repositories

### java

Include the java installation.

### logstash

Include the Logstash installation based in the following [documentation](https://documentation.wazuh.com/current/installation-guide/installing-elastic-stack/index.htmll)


### elasticsearch

Include the Elasticsearch installation based in the following [documentation](https://documentation.wazuh.com/current/installation-guide/installing-elastic-stack/index.htmll)

### kibana

Include the Kibana installation based in the following [documentation](https://documentation.wazuh.com/current/installation-guide/installing-elastic-stack/index.htmll)

Usage
-----

The cookbook can be used to install OSSEC in one of the three types:

* using knife --run-list recipe[wazuh_elastic]. Chef will use the default recipe for the installation.


* [Wazuh Documentation](https://documentation.wazuh.com)
