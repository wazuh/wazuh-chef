# Wazuh - Chef 

[![Slack](https://img.shields.io/badge/slack-join-blue.svg)](https://goo.gl/forms/M2AoZC4b2R9A9Zy12)
[![Email](https://img.shields.io/badge/email-join-blue.svg)](https://groups.google.com/forum/#!forum/wazuh)
[![Documentation](https://img.shields.io/badge/docs-view-green.svg)](https://documentation.wazuh.com)
[![Documentation](https://img.shields.io/badge/web-view-green.svg)](https://wazuh.com)

Deploy Wazuh platform using Chef cookbooks. Chef recipes are prepared for installing and configuring Agent, Manager (cluster) and RESTful API.

## Cookbooks

* [Wazuh Agent ](https://github.com/wazuh/wazuh-chef/tree/master/wazuh_agent)
* [Wazuh Manager and API](https://github.com/wazuh/wazuh-chef/tree/master/wazuh_manager)
* [Elastic Stack (Elasticsearch, Logstash, Kibana)](https://github.com/wazuh/wazuh-chef/tree/master/wazuh_elastic)
* [Filebeat](https://github.com/wazuh/wazuh-chef/tree/master/wazuh_filebeat)

Each cookbook has its own README.md

## Roles

You can find predefined roles for a default installation of Wazuh Agent and Manager in the roles folder.

- [Wazuh Agent Role](https://github.com/wazuh/wazuh-chef/tree/master/roles/wazuh_agent.json)
- [Wazuh Manager Role](https://github.com/wazuh/wazuh-chef/tree/master/roles/wazuh_agent.json)

Check roles README for more information about default attributes and how to customize your installation.

## Installation

#### Cloning whole repository

You can clone repository by running: ```git clone https://github.com/wazuh/wazuh-chef```  and you will get the whole repository.

#### Use through Berkshelf

The easiest way to making use of these cookbooks (especially `wazuh_filebeat` & `wazuh_elastic` until they are published to Supermarket) is by including in your `Berksfile` the desired cookbooks as stated below:

```ruby
cookbook "wazuh_agent", git: "https://github.com/wazuh/wazuh-chef.git",rel: 'cookbooks/wazuh_agent'
cookbook "wazuh_manager", git: "https://github.com/wazuh/wazuh-chef.git",rel: 'cookbooks/wazuh_manager'
cookbook 'wazuh_filebeat', github: 'https://github.com/wazuh/wazuh-chef.git', rel: 'cookbooks/wazuh_filebeat'
cookbook 'wazuh_elastic', github: 'https://github.com/wazuh/wazuh-chef.git', rel: 'cookbooks/wazuh_elastic'
```

You can specify tags, branches and revisions. More info on https://docs.chef.io/berkshelf.html

## Contribute

If you want to contribute to our project please don't hesitate to send a pull request. You can also join our users [mailing list](https://groups.google.com/d/forum/wazuh), by sending an email to [wazuh+subscribe@googlegroups.com](mailto:wazuh+subscribe@googlegroups.com), to ask questions and participate in discussions.

## License and copyright

Wazuh App Copyright (C) 2019 Wazuh Inc. (License GPLv2)


## References

* [Wazuh website](http://wazuh.com)
* [Wazuh mailing list](https://groups.google.com/d/forum/wazuh)
* [Wazuh documentation](http://documentation.wazuh.com)
