# Cookbook Name:: wazuh-manager
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

include_recipe 'wazuh_manager::prerequisites'
include_recipe 'wazuh_manager::repository'
include_recipe 'wazuh_manager::manager'
