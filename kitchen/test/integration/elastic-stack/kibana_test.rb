# frozen_string_literal: true

describe directory '/usr/share/kibana/optimize' do
  its('owner') { should cmp 'kibana' }
  its('group') { should cmp 'kibana' }
end

describe directory '/usr/share/kibana/plugins' do
  its('owner') { should cmp 'kibana' }
  its('group') { should cmp 'kibana' }
end

describe file('/etc/kibana/kibana.yml') do
  its('owner') { should cmp 'kibana' }
  its('group') { should cmp 'kibana' }
  its('mode') { should cmp '0755' }
end

describe file('/usr/share/kibana/optimize/wazuh/config/wazuh.yml') do
  its('owner') { should cmp 'kibana' }
  its('group') { should cmp 'kibana' }
  its('mode') { should cmp '0755' }
end

describe service('kibana') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe port(5601) do
  it { should be_listening }
end
