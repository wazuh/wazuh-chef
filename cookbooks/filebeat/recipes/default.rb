# Cookbook Name:: filebeat
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

include_recipe 'filebeat::repository'
include_recipe 'filebeat::filebeat'
