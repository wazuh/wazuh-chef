# Wazuh Agent cookbook

These cookbooks install and configure a Wazuh Agent on specified nodes.

Currently, the agent is automatically registered using enrollment. check the [documentation](https://documentation.wazuh.com/4.0/user-manual/registering/) for further information. 

Agent is automatically registered against manager using ['agent authd'](https://documentation.wazuh.com/4.0/user-manual/agents/agent-connection.html) tool. The manager IP address has to be declared in the `node['ossec']['address']` attribute. This can be overwriten in two ways: modifyng that attribute in [agent role](../../roles/wazuh_agent.json) or directly in the `node['ossec']['agent_auth']['host']` specific attribute.
 

### Attributes

* ``versions.rb`` contains version attributes to make it easier when it comes to bump version
* The rest of files contains all the default configuration files in order to generate *ossec.conf* 

Check ['ossec.conf']( https://documentation.wazuh.com/3.x/user-manual/reference/ossec-conf/index.html) documentation to see all configuration sections.

### Usage

Create a role following the ['wazuh_agent'](https://github.com/wazuh/wazuh-chef/roles/wazuh_agent.json) role structure and specify your desired configuration attributes. Note that **address** is mandatory.

Assign the current role to desired nodes and run ```chef-client``` on them.

You can declare desired *agent_auth* parameters to customize the registration process.

For example:

```
{
    "name": "wazuh_agent",
    "description": "Wazuh agent",
    "json_class": "Chef::Role",
    "default_attributes": {
    },
    "override_attributes": {
      "ossec": {
        "address": "172.19.0.211",
        "agent_auth": {
          "name" : "Agent_01", 
          "set_group" : "group_01",
          "agent_ip_by_manager": "true"
        }
      }
    },
    "chef_type": "role",
    "run_list": [
      "recipe[wazuh_agent::agent]"
    ],
    "env_run_lists": {
    }
}
```

**Will generate**: ```agent_auth -m 172.19.0.211 -p 1515 -A Agent_01 -G group_01 -i   ```  

The agent_auth parameters are the following:

```
-a  : "auto_negotiate"
-A  : "name"
-m  : "host"
-p  : "port"
-c  : "cipher_list"
-D  : "wazuh_directory"
-d  : "debug_mode" : "true"
-g  : "run_as_group"
-G  : "set_group"
-i  : "agent_ip_by_manager" : "true"
-I  : "agent_ip"
-P  : "password"
-v  : "ca"
-x  : "certificate"
-k  : "key"
```

You can use any of the quoted attributes, as stated in the previous example. Flags options must be set to "true" or "false".


### Recipes

#### agent.rb

Register agent by using agent authd method. You can declare the desired fields to customize the registration process. 

#### common.rb

It generates the ossec.conf file using Gyoku and restarts the wazuh-agent service

#### repository.rb

Declares repository of Wazuh and GPG keys based on different installations.

### References

Check https://documentation.wazuh.com/3.x/user-manual/agents/index.html for more information about Wazuh-Agent.

