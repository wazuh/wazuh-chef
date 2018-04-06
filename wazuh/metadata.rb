name             'wazuh'
maintainer       'Wazuh Inc.'
maintainer_email 'info@wazuh.com'
license          'Apache 2.0'
description      'Installs and onfigures ossec'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url 'https://github.com/wazuh/wazuh-chef/issues'
source_url 'https://github.com/wazuh/wazuh-chef/tree/master/wazuh'
version          '0.0.6'

%w( apt ).each do |pkg|
  depends pkg
end

%w( debian ubuntu ).each do |os|
  supports os
end

depends 'chef-sugar'
depends 'apt'
depends 'poise-python'
depends 'yum'
depends 'hostsfile'
