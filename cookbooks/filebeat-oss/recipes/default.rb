# Cookbook Name:: filebeat
# Recipe:: default
# Author:: Wazuh <info@pwazuh.com>

include_recipe 'apt::default'
include_recipe 'filebeat::repository'
include_recipe 'filebeat::filebeat'