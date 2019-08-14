#
# Cookbook Name:: wazuh-elastic
# Recipe:: java

# Create user and group
#
if node[:platform_family].include?("centos")
  if node[:platform_version].include?("6.")
    yum_package 'java-1.8.0-openjdk'
  end
end