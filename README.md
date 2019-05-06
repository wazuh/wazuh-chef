# Wazuh - Chef cookbooks

[![Slack](https://img.shields.io/badge/slack-join-blue.svg)](https://goo.gl/forms/M2AoZC4b2R9A9Zy12)
[![Email](https://img.shields.io/badge/email-join-blue.svg)](https://groups.google.com/forum/#!forum/wazuh)
[![Documentation](https://img.shields.io/badge/docs-view-green.svg)](https://documentation.wazuh.com)
[![Documentation](https://img.shields.io/badge/web-view-green.svg)](https://wazuh.com)

Deploy Wazuh platform using Chef cookbooks. Chef recipes are prepared for installing and configuring Manager (cluster), Agent and RESTful API.

## Cookbooks

* [Wazuh (Manager, Agent, API)](https://github.com/wazuh/wazuh-chef/tree/master/wazuh)
* [Elastic Stack (Elasticsearch, Logstash, Kibana)](https://github.com/wazuh/wazuh-chef/tree/master/wazuh_elastic)
* [Filebeat](https://github.com/wazuh/wazuh-chef/tree/master/wazuh_filebeat)

Each cookbook has its own README.

## Use through Berkshelf

The easiest way to making use of these cookbooks (especially `wazuh_filebeat` & `wazuh_elastic` until they are published to Supermarket) is by including in your `Berksfile` something like the below:

```ruby
cookbook 'wazuh', github: 'wazuh/wazuh-chef', rel: 'wazuh'
cookbook 'wazuh_filebeat', github: 'wazuh/wazuh-chef', rel: 'wazuh_filebeat'
cookbook 'wazuh_elastic', github: 'wazuh/wazuh-chef', rel: 'wazuh_elastic'
```

This will source all three cookbook housed in this repo from github.

## Contribute

If you want to contribute to our project please don't hesitate to send a pull request. You can also join our users [mailing list](https://groups.google.com/d/forum/wazuh), by sending an email to [wazuh+subscribe@googlegroups.com](mailto:wazuh+subscribe@googlegroups.com), to ask questions and participate in discussions.

## License and copyright

WAZUH
Copyright (C) 2017 Wazuh Inc.  (License GPLv2)


## References

* [Wazuh website](http://wazuh.com)
* [Wazuh mailing list](https://groups.google.com/d/forum/wazuh)
* [Wazuh documentation](http://documentation.wazuh.com)
