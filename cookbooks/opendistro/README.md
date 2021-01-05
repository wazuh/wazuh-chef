# Opendistro cookbook

This cookbook installs and configures Opendistroforleasticsearch. Please note that it's not obligatory to install the whole stack, recipes can work independently.

### Attributes

* ``api.rb``: declare API credentials for all manager installed
* ``jvm.rb``: declare the amount of memory RAM JVM will use
* ``paths.rb``: initialize different paths used during installation
* ``search_guard.rb``: declare search guard ZIP filename 
* ``versions.rb``: versions for Wazuh, ODFE, ELK and Search Guard
* ``elasticsearch.yml.rb``: customize YAML configuration file for Elasticsearch
* ``filebeat.yml.rb``: customize YAML configuration file for Filebeat
* ``searchguard.yml.rb``: customize YAML configuration file for Search Guard

### Usage

Create a role, `opendistro`. Modify attributes to customize the installation.

```json
{
    "name": "opendistro",
    "description": "Opendistro Role",
    "json_class": "Chef::Role",
    "default_attributes": {

    },
    "override_attributes": {

    },
    "chef_type": "role",
    "run_list": [
        "recipe[opendistro::default]"
    ],
    "env_run_lists": {

    }
}
```

### Recipes

#### default.rb

Declares all recipes in the cookbook and installs the whole Elastic Stack.

#### elasticsearch.rb

Installs and configures Elasticsearch. Also install mandatory certificates. 

#### repository.rb 

Declares elastic repository and GPG key URI.

### kibana.rb

Installs and configures Kibana. You can customize the installation by editing the following attributes.

### Elasticsearch 7.x Cluster Changes

ES implements a big change on how clusters are formed and the communication between them. You can check full details here [A-new-era-for-cluster-coordination-in-elasticsearch](https://www.elastic.co/es/blog/a-new-era-for-cluster-coordination-in-elasticsearch)

Elastic adds new parameters that customize the cluster formation: `discovery.seed_hosts`. `discovery.host_provider` and `cluster.initial_master_nodes`  

You can find more information about such attributes here: [Discovery and cluster formation settings](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-settings.html)

In order to make Chef compatible Elasticsearch 7.x, two new attributes could be added.

1. `['elastic']['yml']['discovery']` : This option let you set the full line in the *elasticsearch.yml* file so you can declare it to:
  - `['elastic']['yml']['discovery']['seed_hosts']: <IP>"` 
  - `['elastic']['yml']['discovery']['seed_providers']: <DNS>"` 
  - `['elastic']['yml']['discovery']['type']: single-node"`
2. `['elastic']['yml']['cluster']['initial_master_nodes']`: Allows to insert the whole line for the initial master nodes. You can declare it like:
  - `['elastic']['yml']['cluster']['initial_master_nodes']: "['<IP>']"`

#### Example:

One example of the previously stated configuration would be the following.

If only the declaration of `cluster.initial_master_nodes` to *192.168.0.1* would be wanted, the Elastic role needs to be adapted like this:

```json
{
    "name": "opendistro",
    "description": "Opendistro Role",
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
        "recipe[opendistro::default]"
    ],
    "env_run_lists": {

    }
}

```

### References

Check https://documentation.wazuh.com/current/installation-guide/open-distro/distributed-deployment/step-by-step-installation/elasticsearch-cluster/elasticsearch-single-node-cluster.html for more information about 
how to install step-by-step a Elasticsearch single-node cluster.