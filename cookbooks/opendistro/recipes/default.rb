# Cookbook Name:: opendistro
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

#############################################
include_recipe 'chef-sugar::default'
include_recipe 'wazuh_elastic::prerequisites'
include_recipe 'wazuh_elastic::repository'
include_recipe 'wazuh_elastic::elasticsearch'
include_recipe 'wazuh_elastic::kibana'
