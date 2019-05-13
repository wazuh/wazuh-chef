Wazuh cookbooks
====================================

Requirements
------------
#### Platforms
Tested on Ubuntu and CentOS, but should work on any Unix/Linux platform supported by Wazuh. Installation by default is done from packages.

This cookbooks doesn't configure Windows systems yet. For manual agent installation on Windows, check the [documentation](https://documentation.wazuh.com/current/installation-guide/installing-wazuh-agent/wazuh_agent_windows.html)

#### Chef
- Chef 12+

#### Cookbooks Dependencies
- chef-sugar
- hostsfile
- apt
- yum
- poise-python

Attributes for Agent and Manager
----------

All default attributes files are defined in the ```attributes/``` folder of each cookbook. Chef applies attributes from all attribute files regardless of which recipes were executed. It's important to mention that Chef will load ```default.rb``` first and then will proceed alphabetically. 

### ossec.conf

OSSEC's configuration is mainly read from an XML file called `ossec.conf`. You can directly control the contents of this file using node attributes under `node['ossec']['conf']`. These attributes are mapped to XML using Gyoku. See the [Gyoku site](https://github.com/savonrb/gyoku) for details on how this works.

Values `true` and `false`  are automatically mapped to `"yes"` and `"no"` as OSSEC expects the latter.

`ossec.conf` makes use of XML attributes so you can generally construct nested hashes in the usual fashion. Where an attribute is required, you can do it like this:

```ruby
default['ossec']['conf']['all']['syscheck']['directories'] = [
  { '@check_all' => true, 'content!' => '/bin,/sbin' },
  '/etc,/usr/bin,/usr/sbin'
]
```

This produces:

    <syscheck>
      <directories check_all="yes">/bin,/sbin</directories>
      <directories>/etc,/usr/bin,/usr/sbin</directories>
    </syscheck>

## Customize Installation

**Important note:** Gyoku will hash the defined attributes and the ```ossec.conf``` file will only contain the declared attributes, via default attributes or overridden ones. Any other information will be overwritten and deleted from the file.

If you want to add new fields to customize your installation, you can declare it as a default attribute in it's respective .rb file in the attributes folder or add it manually to the role.

For example: To enable cluster configuration, the following lane would be added to ```/cookbooks/wazuh_manager/attributes/cluster.rb``` .

`````` ruby
default['ossec']['conf']['cluster']['disabled'] == false
``````

This will transform the **disabled** field of from:

```xml
<cluster>
  <name>wazuh</name>
  <node_name>manager_01</node_name>
  <node_type>master</node_type>
  <key>ugdtAnd7Pi9myP7CVts4qZaZQEQcRYZa</key>
  <port>1516</port>
  <bind_addr>0.0.0.0</bind_addr>
  <nodes>
    <node>master</node>
  </nodes>
  <hidden>no</hidden>
  <disabled>yes</disabled>
</cluster>
```

To:

```xml
<cluster>
  <name>wazuh</name>
  <node_name>manager_01</node_name>
  <node_type>master</node_type>
  <key>ugdtAnd7Pi9myP7CVts4qZaZQEQcRYZa</key>
  <port>1516</port>
  <bind_addr>0.0.0.0</bind_addr>
  <nodes>
    <node>master</node>
  </nodes>
  <hidden>no</hidden>
  <disabled>no</disabled>
</cluster>
```



In case you want to customize your installation using roles, you can declare attributes like this: 

```json
{
    "name": "wazuh_manager",
    "description": "Wazuh Manager host",
    "json_class": "Chef::Role",
    "default_attributes": {
		"ossec": {
            "cluster":{
            	"disabled" : "false"
        	}
        }
    },
    "override_attributes": {

    },
    "chef_type": "role",
    "run_list": [
      "recipe[wazuh_manager::manager]"
    ],
    "env_run_lists": {

    }
  }
```

Same example applies for Wazuh Agent and it's own attributes.

You can get more info about attributes and how the work on the chef documentation: https://docs.chef.io/attributes.html

