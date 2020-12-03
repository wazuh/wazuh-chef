# Cookbook Name:: opendistro
# Recipe:: repository
# Author:: Wazuh <info@wazuh.com>

case node['platform'] 
when 'debian','ubuntu'
  package "lsb-release"

  ohai "reload lsb" do
    plugin "lsb"
    subscribes :reload, "package[lsb-release]", :immediately
  end

  # Install GPG key and add repository
  apt_repository "wazuh" do
    uri "https://packages.wazuh.com/#{node['wazuh']['major_version']}/apt/"
    key "https://packages.wazuh.com/key/GPG-KEY-WAZUH"
    distribution "stable"
    components ["main"]
  end  

  # Update the package information
  apt_update
when 'redhat', 'centos', 'amazon', 'fedora', 'oracle'
  yum_repository "wazuh" do
    description "Opendistroforelasticseach Yum"
    baseurl "https://packages.wazuh.com/#{node['wazuh']['major_version']}/yum/"
    gpgkey "https://packages.wazuh.com/key/GPG-KEY-WAZUH"
    action :create
  end
when 'opensuseleap', 'suse'
  zypper_repository "wazuh" do
    description "Opendistroforelasticseach Zypper"
    baseurl "https://packages.wazuh.com/#{node['wazuh']['major_version']}/yum/"
    gpgkey "https://packages.wazuh.com/key/GPG-KEY-WAZUH"
    action :create
    not_if do
      File.exists?("/etc/zypp/repos.d/wazuh.repo")
    end
  end
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end
