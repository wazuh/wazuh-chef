# Elastic Stack cookbook

This cookbook installs and configures Elastic Stack. Please note that it's not obligatory to install the whole stack, recipes can work independently.

#### Chef
- Chef 12+

#### Cookbooks

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

Declares elastic repository and GPG key URLs.

### kibana.rb

Installs Kibana packages and configures *kibana.yml*. You can customize the installation by editing the following attributes.

### Elasticsearch 7.x Cluster Changes

ES implements a big change on how clusters are formed and the communication between them. You can check full details here [A-new-era-for-cluster-coordination-in-elasticsearch](https://www.elastic.co/es/blog/a-new-era-for-cluster-coordination-in-elasticsearch)

Elastic adds new parameters that customize the cluster formation: `discovery.seed_hosts`. `discovery.host_provider` and `cluster.initial_master_nodes`  

You can find more information about such attributes here: [Discovery and cluster formation settings](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-settings.html)

In order to make Chef compatible Elasticsearch 7.x, two new attributes have been added.

- `['wazuh-elastic']['discovery_option']` : This option let you set the full line in the *elasticsearch.yml* file so you can declare it to:
  - `['wazuh-elastic']['discovery_option']: "discovery.seed.hosts: <IP>"` 
  - `['wazuh-elastic']['discovery_option']: "discovery.host_providers: <DNS>"` 
  - `['wazuh-elastic']['discovery_option']: "discovery.type: single-node"`
- `['wazuh-elastic']['elasticsearch_cluster_initial_master_nodes']`: Allows to insert the whole line for the initial master nodes. You can declare it like:
  - `['wazuh-elastic']['elasticsearch_cluster_initial_master_nodes']: "['<IP>']"`

**Important note:** In some situations you will need only one of such parameters, that's why it's implemented as the whole line, to allow the declaration of character **#**  to disable it.

#### Example:

One example of the previously stated configuration would be the following.

If only the declaration of `cluster.initial_master_nodes` to *192.168.0.1* would be wanted, the Elastic role needs to be adapted like this:

```json
{
    "name": "wazuh_elastic",
    "description": "Wazuh Elastic Role",
    "json_class": "Chef::Role",
    "default_attributes": {

    },
    "override_attributes": {
        "wazuh-elastic":{
            "discovery_option": "#",
            "elasticsearch_cluster_initial_master_nodes": "192.168.0.1"
        }

    },
    "chef_type": "role",
    "run_list": [
        "recipe[wazuh_elastic::default]"
    ],
    "env_run_lists": {

    }
}

```



### References

Check https://documentation.wazuh.com/current/installation-guide/installing-elastic-stack/index.html for more information about Wazuh Elastic.