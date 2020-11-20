# -*- encoding: utf-8 -*-
#
# Cookbook Name:: Elastic
# Recipe:: default
#

#############################################
include_recipe 'chef-sugar::default'
include_recipe 'wazuh_elastic::prerequisites'
if node['wazuh-elastic']['elasticsearch']
    include_recipe 'wazuh_elastic::repository'
    include_recipe 'wazuh_elastic::elasticsearch'
elsif node['wazuh-elastic']['odfe']
    include_recipe 'wazuh_elastic::repository'
    include_recipe 'wazuh_elastic::odfe'
#include_recipe 'wazuh_elastic::kibana'
