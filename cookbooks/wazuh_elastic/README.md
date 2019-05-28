# Wazuh Elasticsearch cookbook

This cookbook installs and configure Elastic Stack. Please note that it's not obligatory to install the whole stack, recipes can work independently.

### Attributes

The ``attributes`` folder contains all the default configuration files in order to generate ossec.conf file.

Check ['ossec.conf']( https://documentation.wazuh.com/3.x/user-manual/reference/ossec-conf/index.html) documentation to see all configuration sections.

### Installation

Create a role, `wazuh_elastic`. Modify attributes to customize the installation.

```
{
    "name": "wazuh_elastic",
    "description": "Wazuh Elastic Role",
    "json_class": "Chef::Role",
    "default_attributes": {

    },
    "override_attributes": {

    },
    "chef_type": "role",
    "run_list": [
        "recipe[wazuh_elastic::default]"
    ],
    "env_run_lists": {

    }
}
```

#### Customize ELK installation

You can customize the installation of Elasticsearch and Kibana modifying the following parameters.


**Elasticsearch:**

* ```['wazuh-elastic']['elasticsearch_memmory'] = "1g"```
* ```['wazuh-elastic']['elasticsearch_cluster_name'] = 'wazuh'```
* ```['wazuh-elastic']['elasticsearch_node_name'] = 'elk.wazuh-test.com'```
* ```['wazuh-elastic']['elasticsearch_port'] = 9200```
* ```['wazuh-elastic']['elasticsearch_ip'] = 'localhost'```

**Kibana:**

* ```['wazuh-elastic']['kibana_host'] = '0.0.0.0'```
* ```['wazuh-elastic']['kibana_port'] = '5601'```
* ```['wazuh-elastic']['kibana_elasticsearch_server'] = "http://#{node['wazuh-elastic']['elasticsearch_ip']}:#{node['wazuh-elastic']['elasticsearch_port']}"```


### Recipes

#### default.rb

Declares all recipes in the cookbook and installs the whole Elastic Stack.

#### elasticsearch.rb

Installs Elasticsearch, the Wazuh template will be configured. 

#### repository.rb 

Declares elastic repository and gpg key urls.


### kibana.rb

Installs Kibana packages and configures *kibana.yml*. You can customize the installation by editing the following attributes.

### References

Check https://documentation.wazuh.com/current/installation-guide/installing-elastic-stack/index.html for more information about Wazuh Elastic.

