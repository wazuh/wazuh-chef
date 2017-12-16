# Cookbook Name:: wazuh_elastic
# Recipe:: default
# Author:: Wazuh <info@wazuh.com>

case node['platform_family']
when 'debian'
  package 'lsb-release'

  ohai 'reload lsb' do
    plugin 'lsb'
    # action :nothing
    subscribes :reload, 'package[lsb-release]', :immediately
  end

<<<<<<< HEAD
  apt_repository 'elastic-5.x' do
    uri 'https://artifacts.elastic.co/packages/5.x/apt'
=======
  apt_repository 'elastic-6.x' do
    uri 'https://artifacts.elastic.co/packages/6.x/apt'
>>>>>>> d3e691bba7f9a6a500c6722eb8e57a4110600cbb
    key 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
    distribution "stable"
    components ["main"]
    not_if do
<<<<<<< HEAD
      File.exists?("/etc/apt/sources.list.d/elastic-5.x.list")
    end
  end
when 'rhel'
  yum_repository 'elastic-5.x' do
    description 'Elastic repository for 5.x packages'
    baseurl 'https://artifacts.elastic.co/packages/5.x/yum'
=======
      File.exists?("/etc/apt/sources.list.d/elastic-6.x.list")
    end
  end
when 'rhel'
  yum_repository 'elastic-6.x' do
    description 'Elastic repository for 6.x packages'
    baseurl 'https://artifacts.elastic.co/packages/6.x/yum'
>>>>>>> d3e691bba7f9a6a500c6722eb8e57a4110600cbb
    gpgkey 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
    action :create
  end
end
