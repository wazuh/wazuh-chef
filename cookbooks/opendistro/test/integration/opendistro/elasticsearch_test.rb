# frozen_string_literal: true

if os.family == 'debian'
  describe package('elasticsearch-oss') do
    it { should be_installed }
    its('version') { should eq "#{input('elk_version')}" }
  end
elsif os.family == 'redhat'
  describe package('elasticsearch-oss') do
    it { should be_installed }
    its('version') { should eq "#{input('elk_version')}-1" }
  end
end

describe package('opendistroforelasticsearch') do
  it { should be_installed }
  its('version') { should eq "#{input('odfe_version')}-1" }
end

describe directory '/etc/elasticsearch' do
  its('owner') { should cmp 'elasticsearch' }
  its('group') { should cmp 'elasticsearch' }
end

describe directory '/usr/share/elasticsearch' do
  its('owner') { should cmp 'elasticsearch' }
  its('group') { should cmp 'elasticsearch' }
end

describe file('/etc/elasticsearch/elasticsearch.yml') do
  its('owner') { should cmp 'elasticsearch' }
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
  its('owner') { should cmp 'elasticsearch' }
  its('group') { should cmp 'elasticsearch' }
  its('mode') { should cmp '0660' }
end

describe file('/etc/elasticsearch/certs/root-ca.pem') do
  it { should exist }
end

describe service('elasticsearch') do
  it { should be_installed }
  it { should be_enabled}
  it { should be_running }

end

describe http("https://#{input('node_ip')}:#{input('elastic_port')}",
              auth: {user: "#{input('elastic_user')}", pass: "#{input('elastic_password')}"},
              ssl_verify: false,
              method: 'GET') do
  its('status') { should cmp 200 }
end 
