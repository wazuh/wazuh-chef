# Install all the required utilities

if platform_family?('debian','ubuntu')
    package "lsb-release"
  
    ohai "reload lsb" do
      plugin "lsb"
      # action :nothing
      subscribes :reload, "package[lsb-release]", :immediately
    end
    
    apt_package %w(curl apt-transport-https)

elsif platform_family?('rhel', 'redhat', 'centos')
    if node['platform_version'] >= '8'
        dnf_package 'curl'
    else
        yum_package 'curl' 
    end   
elsif platform_family?('suse')
    zypper_package 'curl'

else
    raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end
