Elastic Stack cookbook
=======================

Installs Elastic Stack. See:

https://documentation.wazuh.com/

Usage
------------
Create a role following the ['wazuh_elastic'](https://github.com/wazuh/wazuh-chef/roles/wazuh_elastic.json) role structure and specify your desired configuration attributes. 

Assign the current role to desired nodes and run `chef-client` on them.

Attributes
----------

* `node['wazuh-elastic']['elasticsearch_cluster_name']` - Defines the cluster name.
* `node['wazuh-elastic']['elasticsearch_node_name']` - Defines the elasticsearch node name.
* `nose['wazuh-elastic']['elasticsearch_port']` - Defines the elasticsearch port.
* `node['wazuh-elastic']['elasticsearch_ip']` = 'localhost' - Defines the elasticsearch ip.

* `node['wazuh-elastic']['kibana_host']` - This setting specifies the IP address of the back end server..
* `node['wazuh-elastic']['kibana_port']` - Kibana is served by a back end server. This setting specifies the port to use.
* `node['wazuh-elastic']['kibana_elasticsearch_server']` - The URL of the Elasticsearch instance to use for all your queries.


Recipes
-------

### default.rb

Includes all recipe to install the full Elastic Stack in the same server

### repository

The *elastic-6.x* repository is added for rhel and debian distributions. GPG Key will be installed.

### java

Installs *openjdk-8* in ubuntu < 16.0 and the *java-1.8.0-openjdk* for redhat and centos distributions.

### logstash

Installs logstash in the specified version and creates the certificates based on `logstash_certificate` secret if it exists, otherwise creates an empty */etc/logstash/logstash.crt* and */etc/logstash/logstash.key* . By default **SSL is disabled**.

You can modify the attribute `['wazuh-elastic']['logstash_configuration']` between *"remote"* and *"local"*  to choose between the type of installation that logstash will be installed.


### elasticsearch

Installs the elasticsearch  and configures the *elasticsearch.yml* and the JVM options (*etc/elasticsearch/jvm.options*). The wazuh template for elasticsearch will be downloaded.

The following attributes are loaded.

* `['wazuh-elastic']['elasticsearch_cluster_name']`

* `['wazuh-elastic']['elasticsearch_node_name']`

* `['wazuh-elastic']['elasticsearch_port']`

* `['wazuh-elastic']['elasticsearch_ip']`

### kibana

Installs kibana according to specified version. Configures *kibana.yml* file according to the following attributes:

* `['wazuh-elastic']['kibana_host']`
* `['wazuh-elastic']['kibana_port']`
* `['wazuh-elastic']['kibana_elasticsearch_server']`

You can modify them to customize your installation.

References
-----

Check https://documentation.wazuh.com/3.x/installation-guide/installing-elastic-stack/index.html for more information about the Elastic Stack installation.