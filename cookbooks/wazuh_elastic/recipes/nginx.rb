if platform_family?('debian', 'ubuntu')
    apt_package 'nginx' do
        action :install
    end
elsif platform_family?('rhel', 'redhat', 'centos', 'amazon')
    yum_package 'nginx' do
        action :install
    end
else
    raise "Platform Family is not in {'debian', 'ubuntu', 'rhel', 'redhat', 'centos', 'amazon'} - Not Supported"
end

