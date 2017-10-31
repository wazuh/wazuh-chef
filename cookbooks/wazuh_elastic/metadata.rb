# -*- encoding: utf-8 -*-
name 'wazuh_elastic'
maintainer 'Wazuh'
maintainer_email 'info@wazuh.com'
license 'All rights reserved'
description 'setup Elastic: logstash, elasticsearch and kibana for Wazuh'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.1'

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
