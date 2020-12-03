# Elastic Stack cookbook

This cookbook installs and configures Elastic Stack. Please note that it's not obligatory to install the whole stack, recipes can work independently.

#### Chef
- Chef 12+

#### Cookbooks

### Attributes

You can customize the installation of Elasticsearch and Kibana modifying the following parameters 
on attributes files:

yml.rb 
======
Has the important parameter to configure the YAML file of elastic and kibana.

**Elasticsearch:**

* ```['elastic']['yml']['network']['host']```: IP address bound to elasticsearch node
* ```['elastic']['yml']['http']['port']```: port bound to elasticsearch node

**Kibana:**

* ```['kibana']['yml']['server']['host']```: IP address bound to kibana node
* ```['kibana']['yml']['server']['port']```: port bound to kibana node
* ```['kibana']['yml']['elasticsearch']['hosts]```: URL of elasticsearch nodes

versions.rb
===========
All the versions for wazuh, elk and kibana plugin

jvm.rb
======
Java memory limits.

paths.rb
========
Default paths for elasticsearch and kibana. Please do not modify.

### Installation

Create a role, `elastic-stack`. Modify attributes to customize the installation.

```json
{
    "name": "elastic-stack",
    "description": "Elastic Stack role",
    "json_class": "Chef::Role",
    "default_attributes": {

    },
    "override_attributes": {

    },
    "chef_type": "role",
    "run_list": [
        "recipe[elastic-stack::default]"
    ],
    "env_run_lists": {

    }
}
```
### Recipes

#### default.rb

Declares all recipes in the cookbook and installs the whole Elastic Stack.

#### elasticsearch.rb

Installs Elasticsearch package and configures *elasticsearch.yml*. 

#### repository.rb 

Declares elastic repository and GPG key URLs.

### kibana.rb

Installs Kibana packages and configures *kibana.yml*. Also install and configures Wazuh Kibana plugin.

### Elasticsearch 7.x Cluster Changes

ES implements a big change on how clusters are formed and the communication between them. You can check full details here [A-new-era-for-cluster-coordination-in-elasticsearch](https://www.elastic.co/es/blog/a-new-era-for-cluster-coordination-in-elasticsearch)

Elastic adds new parameters that customize the cluster formation: `discovery.seed_hosts`. `discovery.host_provider` and `cluster.initial_master_nodes`  

You can find more information about such attributes here: [Discovery and cluster formation settings](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-settings.html)

In order to make Chef compatible Elasticsearch 7.x, two new attributes have been added.

1. `['elastic']['discovery_option']` : This option let you set the full line in the *elasticsearch.yml* file so you can declare it to:
    * `['elastic']['discovery_option']: "discovery.seed.hosts: <IP>"` 
    * `['elastic']['discovery_option']: "discovery.host_providers: <DNS>"` 
    * `['elastic']['discovery_option']: "discovery.type: single-node"`
2. `['elastic']['yml']['cluster']['initial_master_nodes']`: Allows to insert the whole line for the initial master nodes. You can declare it like:
    * `['elastic']['yml']['cluster']['initial_master_nodes']: "['<IP>']"`

**Important note:** In some situations you will need only one of such parameters, that's why it's implemented as the whole line, to allow the declaration of character **#**  to disable it.

#### Example:

One example of the previously stated configuration would be the following.

If only the declaration of `cluster.initial_master_nodes` to *192.168.0.1* would be wanted, the Elastic role needs to be adapted like this:

```json
{
    "name": "elastic-stack",
    "description": "Elastic Stack role",
    "json_class": "Chef::Role",
    "default_attributes": {

    },
    "override_attributes": {
        "elastic": {
            "yml": {
                "cluster": {
                    "initial_master_nodes": "192.168.0.1"
                }
            }
        }
    },
    "chef_type": "role",
    "run_list": [
        "recipe[elastic-stack::default]"
    ],
    "env_run_lists": {

    }
}

```



### References

Check https://documentation.wazuh.com/3.13/installation-guide/installing-elastic-stack/index.html for more information about Wazuh Elastic.