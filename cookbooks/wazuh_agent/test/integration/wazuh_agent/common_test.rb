# Check ossec user
describe user('ossec') do
    it { should exist }
end

# Check processes 

describe command('ps -ef | grep wazuh-modulesd') do
    its('exit_status') { should eq 0 }
end 

describe command('ps -ef | grep ossec-logcollector') do
    its('exit_status') { should eq 0 }
end 

describe command('ps -ef | grep ossec-syscheckd') do
    its('exit_status') { should eq 0 }
end 

describe command('ps -ef | grep ossec-execd') do
    its('exit_status') { should eq 0 }
end 

describe command('ps -ef | grep ossec-agentd') do
    its('exit_status') { should eq 0 }
end 

# Check OSSEC dir

#describe file('/var/ossec/etc/ossec-init.conf') do
#    it { should be_symlink }
#end

describe file('/var/ossec') do
    it { should be_directory }
    its('mode') { should cmp '0750' }
    its('owner') { should cmp 'root' }
    its('group') { should cmp 'ossec' }
end
  
describe file('/var/ossec/etc') do
    it { should be_directory }
    its('mode') { should cmp '0770' }
    its('owner') { should cmp 'ossec' }
    its('group') { should cmp 'ossec' }
end

#describe file('/etc/ossec-init.conf') do 
#    it { should exist }
#    its('owner') { should cmp 'root' }
#    its('group') { should cmp 'ossec' }
#    its('mode') { should cmp '0640' }
#end

describe file('/var/ossec/etc/ossec.conf') do 
    it { should exist }
    its('owner') { should cmp 'root' }
    its('group') { should cmp 'ossec' }
    its('mode') { should cmp '0440' }
end

describe file('/var/ossec/etc/shared/agent.conf') do 
    it { should exist }
    its('owner') { should cmp 'root' }
    its('group') { should cmp 'ossec' }
    its('mode') { should cmp '0440' }
end

describe file('/var/ossec/etc/local_internal_options.conf') do 
    it { should exist }
    its('owner') { should cmp 'root' }
    its('group') { should cmp 'ossec' }
    its('mode') { should cmp '0640' }
end