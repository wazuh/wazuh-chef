# Cookbook Name:: opendistro
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

#include_recipe 'opendistro::prerequisites'
#include_recipe 'opendistro::repository'
#include_recipe 'opendistro::elasticsearch'
include_recipe 'opendistro::kibana'
