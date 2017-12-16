name             'wazuh_ossec'
maintainer       'Wazuh Inc.'
maintainer_email 'jose@wazuh.com'
license          'Apache 2.0'
description      'Installs and onfigures ossec'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
<<<<<<< HEAD
version          '0.0.1'
=======
version          '0.0.5'
>>>>>>> d3e691bba7f9a6a500c6722eb8e57a4110600cbb

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
