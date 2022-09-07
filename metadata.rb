name             'wazuh-chef'
maintainer       'Wazuh'
maintainer_email 'info@wazuh.com'
license          'Apache 2.0'
description      'Installs/Configures Wazuh with chef cookbooks'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '4.2.7'
chef_version     '>= 15.0'

%w(redhat centos oracle).each do |el|
  supports el, '>= 6.0'
end
supports 'amazon', '>= 1.0'
supports 'fedora', '>= 22.0'
supports 'debian', '>= 7.0'
supports 'ubuntu', '>= 12.04'
supports 'suse', '>= 12.0'
supports 'opensuse', '>= 42.0'

issues_url 'https://github.com/wazuh/wazuh-chef/issues' if respond_to?(:issues_url)
source_url 'https://github.com/wazuh/wazuh-chef' if respond_to?(:source_url)