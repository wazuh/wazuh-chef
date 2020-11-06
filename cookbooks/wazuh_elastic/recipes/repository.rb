# Cookbook Name:: wazuh_elastic
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

if platform_family?('debian','ubuntu')
  package "lsb-release"

  ohai "reload lsb" do
    plugin "lsb"
    # action :nothing
    subscribes :reload, "package[lsb-release]", :immediately
  end

  # Install GPG key and add repository
  apt_repository "opendistroforelasticsearch" do
    description "OpenDistro Elasticseach Apt"
    uri "https://packages.wazuh.com/4.x/apt/ "
    key "https://packages.wazuh.com/key/GPG-KEY-WAZUH"
    distribution "stable"
    components ["main"]
    not_if do
      File.exists?("/etc/apt/sources.list.d/wazuh.list")
    end
  end  

  # Update the package information
  apt_update

elsif platform_family?('rhel', 'redhat', 'centos', 'amazon')
  yum_repository "opendistroforelasticsearch" do
    description "OpenDistro Elasticseach Yum"
    baseurl "https://packages.wazuh.com/4.x/yum/"
    gpgkey "https://packages.wazuh.com/key/GPG-KEY-WAZUH"
    action :create
    not_if do
      File.exists?("/etc/yum.repos.d/wazuh.repo")
    end
  end
elsif platform_family?('suse')
  zypper_repository "opendistroforelasticsearch" do
    description "OpenDistro Elasticseach Zypper"
    baseurl "https://packages.wazuh.com/4.x/yum/"
    gpgkey "https://packages.wazuh.com/key/GPG-KEY-WAZUH"
    action :create
    not_if do
      File.exists?("/etc/zypp/repos.d/wazuh.repo")
    end
  end
else
  raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end