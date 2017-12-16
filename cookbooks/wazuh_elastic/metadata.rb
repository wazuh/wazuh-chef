# -*- encoding: utf-8 -*-
name 'wazuh_elastic'
maintainer 'Wazuh'
maintainer_email 'info@wazuh.com'
license 'All rights reserved'
description 'setup Elastic: logstash, elasticsearch and kibana for Wazuh'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
<<<<<<< HEAD
version '0.0.1'
=======
version '0.0.2'
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
