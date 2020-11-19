# Wazuh Server cookbook

This cookbook installs and configure Wazuh Manager, API and Filebeat on specified nodes.

### Attributes 

* ``filebeat.rb`` contains configuration variables and filebeat.yml content
* ``versions.rb`` contains version attributes to make it easier when it comes to bump version
* The rest of files contains all the default configuration files in order to generate ossec.conf 


Check ['Filebeat section'](https://raw.githubusercontent.com/wazuh/wazuh-documentation/4.0/resources/open-distro/filebeat/7.x/filebeat.yml) to see an example of Filebeat configuration.

Check ['ossec.conf'](https://documentation.wazuh.com/4.0/user-manual/reference/ossec-conf/) documentation
to see all configuration sections.

### Installation

Create a role, `wazuh_server`. Add attributes per above as needed to customize the installation.

```
  {
    "name": "wazuh_server",
    "description": "Wazuh Server host",
    "json_class": "Chef::Role",
    "default_attributes": {

    },
    "override_attributes": {

    },
    "chef_type": "role",
    "run_list": [
      "recipe[wazuh_server::default]"
    ],
    "env_run_lists": {

    }
  }
```

If you want to build a Wazuh cluster, you need to create two roles, one role for the **Master** and another one for **Client**:

```
  {
    "name": "wazuh_server_master",
    "description": "Wazuh Server master node",
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
      "recipe[wazuh_server::default]"
    ],
    "env_run_lists": {

    }
  }
  {
    "name": "wazuh_server_client",
    "description": "Wazuh Server client node",
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
      "recipe[wazuh_server::default]"
    ],
    "env_run_lists": {

    }
  }
```

Check [cluster documentation](https://documentation.wazuh.com/4.0/user-manual/configuring-cluster/index.html) for more details

### Recipes

#### manager.rb

Installs the wazuh-manager and required dependencies. Also creates the *local_rules.xml* and *local_decoder.xml* files.

#### filebeat.yml

Install the package Filebeats, create the configuration of */etc/filebeat/filebeat.yml* with defined attributes in the ```attributes``` folder.
#### common.rb

Generates the ossec.conf file using Gyoku.

#### repository.rb 

Declares wazuh repository and gpg key urls.

### References

Check [Wazuh server administration](https://documentation.wazuh.com/4.0/user-manual/manager/index.html) for more information about Wazuh Server.
