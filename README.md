# Wazuh - Chef 

[![Slack](https://img.shields.io/badge/slack-join-blue.svg)](https://goo.gl/forms/M2AoZC4b2R9A9Zy12)
[![Email](https://img.shields.io/badge/email-join-blue.svg)](https://groups.google.com/forum/#!forum/wazuh)
[![Documentation](https://img.shields.io/badge/docs-view-green.svg)](https://documentation.wazuh.com)
[![Documentation](https://img.shields.io/badge/web-view-green.svg)](https://wazuh.com)

Deploy the Wazuh platform using Chef cookbooks. Chef recipes are prepared for installing and configuring Agent, Manager (cluster) and RESTful API.

## Compatibility Matrix

| Wazuh version | Elastic | ODFE   |
|---------------|---------|--------|
| v4.0.1        | -       | v1.11.0|

## Dependencies

Every cookbook will install its own required dependencies, *Berksfile* and *metadata.rb* contains all the information about which dependencies will be installed.

There is software that must be installed to ensure the correct installation.

- Curl
- Wget
- Chef Server Core v12.19.31

## Cookbooks

* [Wazuh Agent ](https://github.com/wazuh/wazuh-chef/tree/master/wazuh_agent)
* [Wazuh Manager and API](https://github.com/wazuh/wazuh-chef/tree/master/wazuh_manager)
* [Elastic Stack (Elasticsearch, Kibana)](https://github.com/wazuh/wazuh-chef/tree/master/wazuh_elastic)
* [Filebeat](https://github.com/wazuh/wazuh-chef/tree/master/wazuh_filebeat)

Each cookbook has its README.md

## Roles

You can find predefined roles for a default installation of Wazuh Agent and Manager in the roles folder.

- [Wazuh Agent Role](https://github.com/wazuh/wazuh-chef/tree/master/roles/wazuh_agent.json)
- [Wazuh Manager Role](https://github.com/wazuh/wazuh-chef/tree/master/roles/wazuh_agent.json)

Check roles README for more information about default attributes and how to customize your installation.

## Installation

#### Cloning whole repository

You can clone the repository by running: ```git clone https://github.com/wazuh/wazuh-chef``` and you will get the whole repository.

#### Use through Berkshelf

The easiest way to making use of these cookbooks (especially `wazuh_filebeat` & `wazuh_elastic` until they are published to Supermarket) is by including in your `Berksfile` the desired cookbooks as stated below:

```ruby
cookbook "wazuh_agent", git: "https://github.com/wazuh/wazuh-chef.git",rel: 'cookbooks/wazuh_agent'
cookbook "wazuh_manager", git: "https://github.com/wazuh/wazuh-chef.git",rel: 'cookbooks/wazuh_manager'
cookbook 'wazuh_filebeat', github: 'https://github.com/wazuh/wazuh-chef.git', rel: 'cookbooks/wazuh_filebeat'
cookbook 'wazuh_elastic', github: 'https://github.com/wazuh/wazuh-chef.git', rel: 'cookbooks/wazuh_elastic'
```

You can specify tags, branches, and revisions. More info on https://docs.chef.io/berkshelf.html

#### Secrets

The following describes how to define the needed JSON files to generate an encrypted data bag.

**Important**: If API user secret is declared will be installed. Otherwise, the default user will be *foo:bar*. 

##### api.json

It contains the username and password that will be installed for Wazuh API authentication. Is required by the manager.

Example of a configuration file `api_configuration.json` before encryption:

```json
{
 "id": "api",
 "htpasswd_user": "<YOUR USER>",
 "htpasswd_passcode": "<YOUR PASSWORD>"
}

```

#### Using Data Bags

To transfer our credentials securely, Chef provides *[data_bags](https://docs.chef.io/data_bags.html)* that allows encrypting some sensitive data before communication.

The following process describes an example of how to create secrets and data bags to encrypt data.

* Install a key or generate one (with OpenSSL for example) on your Workstation ```openssl rand -base64 512 | tr -d '\r\n' > /tmp/encrypted_data_bag_secret```

* Create the required secret by using : ```knife data bag from file wazuh_secrets ./api_configuration.json --secret-file /tmp/encrypted_data_bag_secret -z```

* Upload your new secrets with ```knife upload /```

* Before installing Wazuh-Manager, Wazuh-Filebeat or Wazuh-Elastic you will need to copy the key in */etc/chef/encrypted_data_bag_secret* (default path) or in the desired path (remember to specify the key path in *knife.rb* and *config.rb*) of your workstation.


After encryption, the previous JSON files will have new fields that describe the encryption method and other useful info. For example *api.json* after encryption will look like this:

```json
{
  "id": "api",
  "htpasswd_user": {
    "encrypted_data": "whdiITsM/JFBwiAcCE5MaVE2MinRLdDIGbJ0\n",
    "iv": "NVK/ezXHBsSFuiMm\n",
    "auth_tag": "NFPZcxGrjqxRSF7v/+i6Kw==\n",
    "version": 3,
    "cipher": "aes-256-gcm"
  },
  "htpasswd_passcode": {
    "encrypted_data": "rX952YaNifO1gtcFXHxjteKCk6Zi592FZGgyE1gs0A==\n",
    "iv": "LThJWRCIB4JaDP4E\n",
    "auth_tag": "2oS9JDBtNdcRhsOdgg/A9A==\n",
    "version": 3,
    "cipher": "aes-256-gcm"
  }
}
```


#### Using Chef Vault

Chef Vault provides an easier way to manage Data bags and configure them. To configure it you can follow these steps:

* Configure *knife.rb* or *config.rb* and add `knife[:vault_mode] = 'client'` to make the workstation transfer vault to the server.

* Create the vault with:

```
knife vault create wazuh_secrets api '{"id": "api", "htpasswd_user": "user", "htpasswd_passcode": "password"}' -A "username" -C "manager-1"
```
Where `-A` defines the workstation users authorized to modify/edit the vault and `-C` defines the nodes that have access to the defined vault.

After that, the vault will be created and synced with the server. The defined nodes will store the required keys to decrypt the vault content and consume it.

You can check Chef Official Documentation about [Chef Vault](https://docs.chef.io/chef_vault.html) for detailed info.

## Use through Berkshelf

The easiest way to making use of these cookbooks (especially `wazuh_filebeat` & `wazuh_elastic` until they are published to Supermarket) is by including in your `Berksfile` something like the below:

```ruby
cookbook 'wazuh', gitHub: 'wazuh/wazuh-chef', rel: 'wazuh'
cookbook 'wazuh_filebeat', gitHub: 'wazuh/wazuh-chef', rel: 'wazuh_filebeat'
cookbook 'wazuh_elastic', gitHub: 'wazuh/wazuh-chef', rel: 'wazuh_elastic'
```

This will source all three cookbooks housed in this repo from GitHub.

## Choose to register an agent into a manager or not
Now we give the possibility to choose to register an agent after being configured and installed in a manager. 

In order to do so, it's only needed to assign the value `yes` to the variable ` default['ossec']['agent_auth']['register'] ` in the attributes file_ ` wazuh-chef/cookbooks/wazuh_agent/attributes/authd.rb `:

```
default['ossec']['agent_auth']['register'] = 'yes'
```

To connect an agent with the manager simply modify the `wazuh-chef/roles/wazuh_agent.json` with the desired IP address:

```
"registration_address": "<YOUR REGISTRATION IP ADDRESS>",
"address": "<YOUR MANAGER IP ADDRESS>"
```

In other case, we just assign a different value which is not `yes`.

## Contribute

If you want to contribute to our project please don't hesitate to send a pull request. You can also join our users [mailing list](https://groups.google.com/d/forum/wazuh), by sending an email to [wazuh+subscribe@googlegroups.com](mailto:wazuh+subscribe@googlegroups.com), to ask questions and participate in discussions.


## License and copyright

Wazuh App Copyright (C) 2019 Wazuh Inc. (License GPLv2)


## References

* [Wazuh website](http://wazuh.com)
* [Wazuh mailing list](https://groups.google.com/d/forum/wazuh)
* [Wazuh documentation](http://documentation.wazuh.com)
