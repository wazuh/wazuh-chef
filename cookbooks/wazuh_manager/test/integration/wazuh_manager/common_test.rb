# Check ossec users
describe user('wazuh') do
    it { should exist }
end

# Check processes 

describe command('ps -ef | grep wazuh-modulesd') do
    its('exit_status') { should eq 0 }
end 

describe command('ps -ef | grep wazuh-monitord') do
    its('exit_status') { should eq 0 }
end 

describe command('ps -ef | grep wazuh-logcollector') do
    its('exit_status') { should eq 0 }
end 

describe command('ps -ef | grep wazuh-remoted') do
    its('exit_status') { should eq 0 }
end 

describe command('ps -ef | grep wazuh-syscheckd') do
    its('exit_status') { should eq 0 }
end 

describe command('ps -ef | grep wazuh-analysisd') do
    its('exit_status') { should eq 0 }
end 

describe command('ps -ef | grep wazuh-execd') do
    its('exit_status') { should eq 0 }
end 

describe command('ps -ef | grep wazuh-db') do
    its('exit_status') { should eq 0 }
end 

describe command('ps -ef | grep wazuh-authd') do
    its('exit_status') { should eq 0 }
end 

describe command('ps -ef | grep wazuh-apid') do
    its('exit_status') { should eq 0 }
end 

# Check OSSEC dir

describe file('/var/ossec') do
    it { should be_directory }
    its('mode') { should cmp '0750' }
    its('owner') { should cmp 'root' }
    its('group') { should cmp 'wazuh' }
end
  
describe file('/var/ossec/etc') do
    it { should be_directory }
    its('mode') { should cmp '0770' }
    its('owner') { should cmp 'wazuh' }
    its('group') { should cmp 'wazuh' }
end

describe file('/var/ossec/etc/shared/default/agent.conf') do 
    it { should exist }
    its('owner') { should cmp 'wazuh' }
    its('group') { should cmp 'wazuh' }
    its('mode') { should cmp '0660' }
end

describe file('/var/ossec/etc/local_internal_options.conf') do 
    it { should exist }
    its('owner') { should cmp 'root' }
    its('group') { should cmp 'wazuh' }
    its('mode') { should cmp '0640' }
end

describe file('/var/ossec/etc/rules/local_rules.xml') do 
    it { should exist }
    its('owner') { should cmp 'root' }
    its('group') { should cmp 'wazuh' }
    its('mode') { should cmp '0640' }
end

describe file('/var/ossec/etc/decoders/local_decoder.xml') do 
    it { should exist }
    its('owner') { should cmp 'root' }
    its('group') { should cmp 'wazuh' }
    its('mode') { should cmp '0640' }
end

describe file('/var/ossec/api/configuration/api.yaml') do 
    it { should exist }
    its('owner') { should cmp 'root' }
    its('group') { should cmp 'wazuh' }
    its('mode') { should cmp '0660' }
end


