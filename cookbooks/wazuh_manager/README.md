# Wazuh Manager cookbook

This cookbook installs and configure Wazuh Manager and API on specified nodes.

### Attributes

The ``attributes`` folder contains all the default configuration files in order to generate ossec.conf file.

Check ['ossec.conf']( https://documentation.wazuh.com/3.x/user-manual/reference/ossec-conf/index.html) documentation to see all configuration sections.

### Installation

Create a role, `wazuh_manager`. Add attributes per above as needed to customize the installation.

```
  {
    "name": "wazuh_manager",
    "description": "Wazuh Manager host",
    "json_class": "Chef::Role",
    "default_attributes": {

    },
    "override_attributes": {

    },
    "chef_type": "role",
    "run_list": [
      "recipe[wazuh::manager]"
    ],
    "env_run_lists": {

    }
  }
```

If you want to build a Wazuh cluster, you need to create two roles, one role for the **Master** and another one for **Client**:

**Note**: This Chef cookbook only brings compatibility with **CentOS 7**, we are working on add more distributions soon.

```
  {
    "name": "wazuh_manager_master",
    "description": "Wazuh Manager master node",
    "json_class": "Chef::Role",
    "default_attributes": {

    },
    "override_attributes": {
      "ossec": {
        "cluster_disabled": "no",
        "conf": {
          "server": {
            "cluster": {
              "node_name": "node01",
              "node_type": "master",
              "disabled": "no",
              "nodes": {
                "node": ["172.16.10.10", "172.16.10.11"]
              "key": "596f6b328c8ca831a03f7c7ca8203e8b"
            }
          }
        }
    },
    "chef_type": "role",
    "run_list": [
      "recipe[wazuh::manager]"
    ],
    "env_run_lists": {

    }
  }
  {
    "name": "wazuh_manager_client",
    "description": "Wazuh Manager client node",
    "json_class": "Chef::Role",
    "default_attributes": {

    },
    "override_attributes": {
      "ossec": {
        "cluster_disabled": "no",
        "conf": {
          "server": {
            "cluster": {
              "node_name": "node02",
              "node_type": "client",
              "disabled": "no",
              "nodes": {
                "node": ["172.16.10.10", "172.16.10.11"]
              "key": "596f6b328c8ca831a03f7c7ca8203e8b"
            }
          }
        }
    },
    "chef_type": "role",
    "run_list": [
      "recipe[wazuh::manager]"
    ],
    "env_run_lists": {

    }
  }
```

Check cluster documentation for more details: <https://documentation.wazuh.com/current/user-manual/manager/wazuh-cluster.html>

### Recipes

#### manager.rb

Installs the wazuh-manager and required dependencies. Also creates the ```local_rules.xml``` and ```local_decoder.xml``` files.

#### common.rb

Generates the ossec.conf file using Gyoku.

#### repository.rb 

Declares wazuh repository and gpg key urls.

#### wazuh_api.rb

Installs node.js and wazuh-api. Default api credentials are foo:bar.

### References

Check https://documentation.wazuh.com/current/user-manual/manager/index.html for more information about Wazuh Manager.

