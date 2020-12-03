# Cookbook Name:: wazuh-manager
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

include_recipe 'opendistro::default'
include_recipe 'wazuh_manager::prerequisites'
include_recipe 'wazuh_manager::repository'
include_recipe 'wazuh_manager::manager'
include_recipe 'filebeat-oss::default'
