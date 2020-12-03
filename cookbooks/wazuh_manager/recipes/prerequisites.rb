# Cookbook Name:: wazuh-manager
# Recipe:: prerequisites
# Author:: Wazuh <info@wazuh.com>

# Install all the required utilities

case node['platform']
when 'debian', 'ubuntu'
    package "lsb-release"
  
    ohai "reload lsb" do
      plugin "lsb"
      subscribes :reload, "package[lsb-release]", :immediately
    end
    
    apt_package %w(curl apt-transport-https lsb-release gnupg2)
when 'redhat', 'centos', 'amazon', 'fedora', 'oracle'   
    if node['platform_version'] >= '8'
        dnf_package 'curl'
    else
        yum_package 'curl' 
    end   
when 'opensuseleap', 'suse'
    zypper_package 'curl'
else
    raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end
