ossec cookbook
==============

Installs Wazuh manager and agents. See:

https://documentation.wazuh.com

Requirements
------------
#### Platforms
Tested on Ubuntu and CentOS, but should work on any Unix/Linux platform supported by Wazuh. Installation by default is done from packages.

This cookbook doesn't configure Windows systems yet. For information on installing Wazuh on Windows, see the [free chapter](https://documentation.wazuh.com/current/installation-guide/installing-wazuh-agent/wazuh_agent_windows.html)

#### Chef
- Chef 12+

#### Cookbooks
- apt
- yum

Attributes
----------

* `node['ossec']['dir']` - Installation directory for OSSEC, default `/var/ossec`. All existing packages use this directory so you should not change this.
* `node['ossec']['server_role']` - When using server/agent setup, this role is used to search for the OSSEC server, default `ossec_server`.
* `node['ossec']['agent_server_ip']` - The IP of the OSSEC server. The client recipe will attempt to determine this value via search. Default is nil, only required for agent installations.

###ossec.conf

OSSEC's configuration is mainly read from an XML file called `ossec.conf`. You can directly control the contents of this file using node attributes under `node['ossec']['conf']`. These attributes are mapped to XML using Gyoku. See the [Gyoku site](https://github.com/savonrb/gyoku) for details on how this works.

Chef applies attributes from all attribute files regardless of which recipes were executed. In order to make wrapper cookbooks easier to write, `node['ossec']['conf']` is divided into the three installation types mentioned below, `local`, `server`, and `agent`. You can also set attributes under `all` to apply settings across all installation types. The typed attributes are automatically deep merged over the `all` attributes in the normal Chef manner.

`true` and `false` values are automatically mapped to `"yes"` and `"no"` as OSSEC expects the latter.

`ossec.conf` makes little use of XML attributes so you can generally construct nested hashes in the usual fashion. Where an attribute is required, you can do it like this:

    default['ossec']['conf']['all']['syscheck']['directories'] = [
      { '@check_all' => true, 'content!' => '/bin,/sbin' },
      '/etc,/usr/bin,/usr/sbin'
    ]

This produces:

    <syscheck>
      <directories check_all="yes">/bin,/sbin</directories>
      <directories>/etc,/usr/bin,/usr/sbin</directories>
    </syscheck>

The default values are based on those given in the Wazuh manual. They do not include any specific rules, checks, outputs, or alerts as everyone has different requirements.

###agent.conf

OSSEC servers can also distribute configuration to agents through the centrally managed XM file called `agent.conf`. Since Chef is better at distributing configuration than Wazuh is, the cookbook leaves this file blank by default. Should you want to populate it, it is done in a similar manner to the above. Since this file is only used on servers, you can define the attributes directly under `node['ossec']['agent_conf']`. Unlike conventional XML files, `agent.conf` has multiple root nodes so `node['ossec']['agent_conf']` must be treated as an array like so.

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

###repository

Adds the Wazuh repository. This recipe is included by others and should not be used directly. For highly customised setups, you should use `wazuh_ossec::install_agent`.

###install_agent

Installs the agent packages but performs no explicit configuration.


###common

Puts the configuration file in place and starts the (agent or server) service. This recipe is included by other recipes and generally should not be used directly.

Note that the service will not be started if the client.keys file is missing or empty. For agents, this results in an error.

###agent

Wazuh uses the term `agent` instead of client. The agent recipe includes the `wazuh_ossec::agent` recipe.


###manager

Sets up a system to be an Wazuh server. To allow registration with a new server after changing `agent_server_ip`, delete the client.keys file and rerun the recipe..


Enable agentless monitoring in Wazuh and register the hosts on the server. Automated configuration of agentless nodes is not yet supported by this cookbook. For more information on the commands and configuration directives required in `ossec.conf`, see the [Wazuh Documentation](https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/agentless.html)

Usage
-----

The cookbook can be used to install OSSEC in one of the three types:

* server - use the wazuh_ossec::manager recipe.
* agent - use the wazuh_ossec::agent recipe
* API - use the wazuh_ossec::wazuh-api recipe

For the Wazuh server, create a role, `wazuh_server`. Add attributes per above as needed to customize the installation.
```
  {
    "name": "wazuh_server",
    "description": "",
    "json_class": "Chef::Role",
    "default_attributes": {

    },
    "override_attributes": {

    },
    "chef_type": "role",
    "run_list": [
      "recipe[wazuh_ossec::manager]"
    ],
    "env_run_lists": {

    }
  }
```

For OSSEC agents, create a role, `wazuh_agent`.

```
  {
    "name": "wazuh_agent",
    "description": "",
    "json_class": "Chef::Role",
    "default_attributes": {

    },
    "override_attributes": {
      "ossec": {
        "hostname_server_ip": "manager.wazuh.com"
      }
    },
    "chef_type": "role",
    "run_list": [
      "recipe[wazuh_ossec::agent]"
    ],
    "env_run_lists": {

    }
  }
```

Customization
----

The main configuration file is maintained by Chef as a template, `ossec.conf.erb`. It should just work on most installations, but can be customized for the local environment. Notably, the rules, ignores and commands may be modified.

Further reading:

* [Wazuh Documentation](https://documentation.wazuh.com)
