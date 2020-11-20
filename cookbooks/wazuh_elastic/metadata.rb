name 'wazuh_elastic'
maintainer 'Wazuh'
maintainer_email 'info@wazuh.com'
license 'All rights reserved'
description 'setup Elastic: elasticsearch and kibana for Wazuh'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

%w( apt ).each do |pkg|
  depends pkg
end

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
depends 'htpasswd'
depends 'zypper'

issues_url 'https://github.com/wazuh/wazuh-chef/issues' if respond_to?(:issues_url)
source_url 'https://github.com/wazuh/wazuh-chef' if respond_to?(:source_url)
chef_version '>= 12.0' if respond_to?(:chef_version)