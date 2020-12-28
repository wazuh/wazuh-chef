# Cookbook Name:: filebeat-oss
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

include_recipe 'filebeat-oss::repository'
include_recipe 'filebeat-oss::filebeat'