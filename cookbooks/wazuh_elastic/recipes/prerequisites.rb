if platform_family?('debian','ubuntu')
    package "lsb-release"
  
    ohai "reload lsb" do
      plugin "lsb"
      # action :nothing
      subscribes :reload, "package[lsb-release]", :immediately
    end
    
    # Install apt prerequisites
    apt_package %w(curl apt-transport-https unzip wget software-properties-common libcap2-bin)

    # Add the repository for Java Development Kit (JDK)
    case platform_family?
    when 'debian'
        bash 'add backports.list' do
            code <<-EOH
            echo 'deb http://deb.debian.org/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list
            EOH
        end
    when 'ubuntu'
        execute 'add apt repository' do
            command 'add-apt-repository ppa:openjdk-r/ppa'
        end
    else 'Error: cannot install JDK dependancie'
    end

    # Update repository data
    apt_update

    # Install all the required utilities
    execute 'export JAVA_HOME' do
        command  'export JAVA_HOME=/usr/'
    end
    apt_package 'openjdk-11-jdk'



elsif platform_family?('rhel', 'redhat', 'centos', 'amazon')
    
    # Install all the necessary packages for the installation
    execute 'export JAVA_HOME' do
        command  'export JAVA_HOME=/usr/'
    end

    yum_package 'prerequisites' do
        package_name ['curl', 'unzip', 'wget', 'java-11-openjdk-devel', 'libcap']
        action :install
    end

elsif platform_family?('suse')
    # Install zypper prerequisites
    zypper_package 'prerequisites' do
        package_name ['curl', 'unzip', 'wget', 'libcap2']
    end
else
    raise "Currently platforn not supported yet. Feel free to open an issue on https://www.github.com/wazuh/wazuh-chef if you consider that support for a specific OS should be added"
end
