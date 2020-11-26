# Cookbook Name:: elastis-stack
# Recipe:: prerequisites
# Author:: Wazuh <info@wazuh.com>

if platform_family?('debian','ubuntu')
    package "lsb-release"
  
    ohai "reload lsb" do
      plugin "lsb"
      subscribes :reload, "package[lsb-release]", :immediately
    end
    
    # Install debian prerequisites
    apt_package %w(curl apt-transport-https)
end
