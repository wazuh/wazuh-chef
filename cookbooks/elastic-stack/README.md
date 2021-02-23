# Elastic Stack cookbook

This cookbook installs and configures Elastic Stack. Please note that it's not obligatory to install the whole stack, recipes can work independently.

### Attributes

* ``api.rb``: declare API credentials for all manager installed
* ``jvm.rb``: declare the amount of memory RAM JVM will use
* ``paths.rb``: initialize different paths used during installation
* ``versions.rb``: versions for Wazuh and ELK
* ``elasticsearch.yml.rb``: customize YAML configuration file for Elasticsearch
* ``filebeat.yml.rb``: customize YAML configuration file for Filebeat
* ``network.rb``: network parameters and auth credentials

### Usage

Create a role, `elastic-stack`. Modify attributes to customize the installation.

```json
{
    "name": "elastic-stack",
    "description": "Elastic Stack role",
    "json_class": "Chef::Role",
    "default_attributes": {
        "network": {
            "elasticsearch": {
                "ip": "<ELASTICSEARCH_IP>",
                "port": "9200",
                "user": "elastic",
                "password": "<ELASTICSEARCH_PASSWORD>",
            },
            "kibana": {
                "ip": "<KIBANA_IP>",
                "port": 443
            },
            "wazuh": {
                "ip": "<WAZUH_API_IP>",
                "port": 55000
            }
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

In order to make Chef compatible Elasticsearch 7.x, two new attributes could be added.

1. `['elastic']['yml']['discovery']` : This option let you set the full line in the *elasticsearch.yml* file so you can declare it to:
  - `['elastic']['yml']['discovery']['seed_hosts']: <IP>"` 
  - `['elastic']['yml']['discovery']['seed_providers']: <DNS>"` 
  - `['elastic']['yml']['discovery']['type']: single-node"`
2. `['elastic']['yml']['cluster']['initial_master_nodes']`: Allows to insert the whole line for the initial master nodes. Usage example:
  - `['elastic']['yml']['cluster']['initial_master_nodes']: "['<IP>']"`

#### Example:

One example of the previously stated configuration would be the following:

The hereunder example shows a simple configuration override for `initial_master_nodes` variable:

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

Check https://documentation.wazuh.com/current/learning-wazuh/build-lab/install-elastic-stack.html for more information about 
how to install Elastic Stack.
