# frozen_string_literal: true

describe package('elasticsearch-oss') do
  it { should be_installed }
end

describe package('opendistroforelasticsearch') do
  it { should be_installed }
end

describe elasticsearch do
  its('node_name') { should cmp 'es-node-01' }
  its('cluster_name') { should cmp 'es-wazuh' }
  its('url') { should cmp 'http://localhost:9200' }
end

describe directory '/etc/elasticsearch' do
  its('owner') { should cmp 'elasticsearch' }
  its('group') { should cmp 'elasticsearch' }
end

describe directory '/usr/share/elasticsearch' do
  its('owner') { should cmp 'elasticsearch' }
  its('group') { should cmp 'elasticsearch' }
end

describe directory '/var/lib/elasticsearch' do
  its('owner') { should cmp 'elasticsearch' }
  its('group') { should cmp 'elasticsearch' }
end

describe file('/etc/elasticsearch/elasticsearch.yml') do
  its('owner') { should cmp 'root' }
  its('group') { should cmp 'elasticsearch' }
  its('mode') { should cmp '0660' }
end

describe file('/usr/share/elasticsearch/plugins/opendistro_security/securityconfig/roles.yml') do
  it { should exist }
end

describe file('/usr/share/elasticsearch/plugins/opendistro_security/securityconfig/roles_mapping.yml') do
  it { should exist }
end

describe file('/usr/share/elasticsearch/plugins/opendistro_security/securityconfig/internal_users.yml') do
  it { should exist }
end

describe file('/etc/searchguard/search-guard.yml') do
  its('owner') { should cmp 'root' }
  its('group') { should cmp 'elasticsearch' }
  its('mode') { should cmp '0660' }
end

describe file('/etc/elasticsearch/certs/root-ca.pem') do
  it { should exist }
end

describe service('elasticsearch') do
  it { should be_running }
end

describe port(9200) do
  it { should be_listening }
end
