# -*- encoding: utf-8 -*-
#
# Cookbook Name:: Elastic
# Recipe:: default
#

#############################################
include_recipe 'chef-sugar::default'

include_recipe 'wazuh_elastic::java'
include_recipe 'wazuh_elastic::repository'
include_recipe 'wazuh_elastic::elasticsearch'
include_recipe 'wazuh_elastic::logstash'
include_recipe 'wazuh_elastic::kibana'
