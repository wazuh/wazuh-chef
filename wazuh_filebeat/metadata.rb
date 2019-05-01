name             'wazuh_filebeat'
maintainer       'Wazuh'
maintainer_email 'info@wazuh.com'
license          'Apache 2.0'
description      'Installs and configures filebeat'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

supports 'debian'
supports 'ubuntu'

depends 'apt'

issues_url 'https://github.com/wazuh/wazuh-chef/issues'
source_url 'https://github.com/wazuh/wazuh-chef'
chef_version '>= 12.14'
