
describe 'wazuh::agent' do
  describe package('ossec-hids-agent') do
    it { should be_installed }
  end
  describe file('/etc/ossec-init.conf') do
    it { should be_symlink }
  end
  describe file('/var/ossec/etc/ossec.conf') do
    it { should exist }
    it { should be_mode 440 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'ossec' }
  end
  describe file('/var/ossec/etc/ossec-init.conf') do
    it { should exist }
    it { should be_mode 550 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'ossec' }
  end
  describe process('ossec-syscheckd') do
    it { should be_running }
    its(:user) { should eq 'root' }
  end
  describe process('ossec-agentd') do
    it { should be_running }
    its(:user) { should eq 'ossec' }
  end
  describe process('ossec-logcollector') do
    it { should be_running }
    its(:user) { should eq 'root' }
  end
end
