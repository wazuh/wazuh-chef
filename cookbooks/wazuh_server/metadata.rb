name             'wazuh_manager'
maintainer       'Wazuh Inc.'
maintainer_email 'info@wazuh.com'
license          'Apache 2.0'
description      'Installs and onfigures ossec'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

%w(redhat centos oracle).each do |el|
  supports el, '>= 6.0'
end

supports 'amazon', '>= 2.0'
supports 'fedora', '>= 32.0'
supports 'debian', '>= 7.0'
supports 'ubuntu', '>= 14.04'
supports 'suse', '>= 15.0'
supports 'debian', '>= 8.0'
supports 'ubuntu', '>= 14.04'

depends 'chef-sugar'
depends 'apt'
depends 'poise-python'
depends 'yum'
depends 'hostsfile'
depends 'zypper'
depends 'yaml'

issues_url 'https://github.com/wazuh/wazuh-chef/issues' if respond_to?(:issues_url)
source_url 'https://github.com/wazuh/wazuh-chef' if respond_to?(:source_url)
chef_version '>= 12.0' if respond_to?(:chef_version)
