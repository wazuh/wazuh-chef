Wazuh cookbook (Manager, Agent, API)
====================================

Requirements
------------
#### Platforms
Tested on Ubuntu and CentOS, but should work on any Unix/Linux platform supported by Wazuh. Installation by default is done from packages.

This cookbook doesn't configure Windows systems yet. For manual agent installation on Windows, check the [documentation](https://documentation.wazuh.com/current/installation-guide/installing-wazuh-agent/wazuh_agent_windows.html)

#### Chef
- Chef 12+

#### Cookbooks
- apt
- yum

Attributes
----------

* `node['ossec']['agent_server_ip']` - Manager server IP address. The client recipe will attempt to determine this value via search. Default is nil, only required for agent installations.

### ossec.conf

OSSEC's configuration is mainly read from an XML file called `ossec.conf`. You can directly control the contents of this file using node attributes under `node['ossec']['conf']`. These attributes are mapped to XML using Gyoku. See the [Gyoku site](https://github.com/savonrb/gyoku) for details on how this works.

Chef applies attributes from all attribute files regardless of which recipes were executed. In order to make wrapper cookbooks easier to write, `node['ossec']['conf']` is divided into the three installation types mentioned below, `local`, `server`, and `agent`. You can also set attributes under `all` to apply settings across all installation types. The typed attributes are automatically deep merged over the `all` attributes in the normal Chef manner.

`true` and `false` values are automatically mapped to `"yes"` and `"no"` as OSSEC expects the latter.

`ossec.conf` makes use of XML attributes so you can generally construct nested hashes in the usual fashion. Where an attribute is required, you can do it like this:

    default['ossec']['conf']['all']['syscheck']['directories'] = [
      { '@check_all' => true, 'content!' => '/bin,/sbin' },
      '/etc,/usr/bin,/usr/sbin'
    ]

This produces:

    <syscheck>
      <directories check_all="yes">/bin,/sbin</directories>
      <directories>/etc,/usr/bin,/usr/sbin</directories>
    </syscheck>

### agent.conf

Wazuh managers can also distribute configuration to agents using the centralized configuration located in the XML file called `agent.conf`. It as well support groups granularity for different configurations.
Since Chef can as well distribute configuration, the cookbook leaves this file blank by default. In case you want to populate it, you can define the attributes directly under `node['ossec']['agent_conf']`. Unlike conventional XML files, `agent.conf` has multiple root nodes so `node['ossec']['agent_conf']` must be treated as an array like so.

    default['ossec']['agent_conf'] = [
      {
        'syscheck' => { 'frequency' => 4321 },
        'rootcheck' => { 'disabled' => true }
      },
      {
        '@os' => 'Windows',
        'content!' => {
          'syscheck' => { 'frequency' => 1234 }
        }
      }
    ]

This produces:

    <agent_config>
      <syscheck>
        <frequency>4321</frequency>
      </syscheck>
      <rootcheck>
        <disabled>yes</disabled>
      </rootcheck>
    </agent_config>

    <agent_config os="Windows">
      <syscheck>
        <frequency>1234</frequency>
      </syscheck>
    </agent_config>

Recipes
-------

### repository

Adds the Wazuh apt/yum repository. This recipe is included by others and should not be used directly.

### common

The recipe is used for both Manager and Agents, it generates the configuration files ossec.conf and agent.conf.
Puts the configuration file in place and starts the (agent or server) service. This recipe is included by other recipes and generally should not be used directly.

### manager

Install and register a Wazuh manager.

### agent

Install and register a Wazuh agent.


Usage
-----

The cookbook is used for installing Wazuh in one of the three types:

* manager - use the wazuh::manager recipe.
* agent - use the wazuh::agent recipe
* RESTful API - use the wazuh::wazuh-api recipe

For the Wazuh server, create a role, `wazuh_manager`. Add attributes per above as needed to customize the installation.

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
```

```
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
Check cluster documentation for more details: https://documentation.wazuh.com/current/user-manual/manager/wazuh-cluster.html


For Wazuh agents, create a role, `wazuh_agent`.

```
  {
    "name": "wazuh_agent",
    "description": "Wazuh agent",
    "json_class": "Chef::Role",
    "default_attributes": {

    },
    "override_attributes": {
      "ossec": {
        "registration_address": "manager-master.wazuh-test.com",
        "address": ["manager-master.wazuh-test.com", "manager-client.wazuh-test.com"],
      }
    },
    "chef_type": "role",
    "run_list": [
      "recipe[wazuh::agent]"
    ],
    "env_run_lists": {

    }
  }
```

Customization
-------------

The main configuration file is maintained by Chef as a template, `ossec.conf.erb`.
