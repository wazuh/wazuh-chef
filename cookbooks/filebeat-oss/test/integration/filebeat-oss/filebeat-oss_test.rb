describe package('filebeat') do
    it { should be_installed }
end

describe file('/etc/filebeat/filebeat.yml') do
    its('owner') { should cmp 'root' }
    its('group') { should cmp 'root' }
    its('mode') { should cmp '0640'}
end

describe file('/etc/filebeat/wazuh-template.json') do
    its('owner') { should cmp 'root' }
    its('group') { should cmp 'root' }
    its('mode') { should cmp '0644'}
end

describe directory('/usr/share/filebeat/module/wazuh') do
    it { should exist }
end

describe directory('/etc/filebeat/certs') do
    it { should exist }
end