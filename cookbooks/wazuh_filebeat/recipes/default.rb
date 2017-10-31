#
# Cookbook Name:: filebeat
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

include_recipe 'wazuh_filebeat::repository'

include_recipe 'wazuh_filebeat::filebeat'
