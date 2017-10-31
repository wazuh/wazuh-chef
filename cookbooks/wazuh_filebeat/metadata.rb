name             'wazuh_filebeat'
maintainer       'Wazuh'
maintainer_email 'info@wazuh.com'
license          'Apache 2.0'
description      'Installs and configures filebeat'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports 'debian'
supports 'ubuntu'

depends 'apt'
