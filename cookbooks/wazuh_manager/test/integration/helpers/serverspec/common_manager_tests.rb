
describe 'wazuh::manager' do
  describe user('ossecm') do
    it { should exist }
  end
  describe user('ossecr') do
    it { should exist }
  end
  describe file('/var/ossec/etc/wazuh_decoders') do
    it { should be_directory }
    it { should be_mode 550 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'ossec' }
  end
  describe file('/etc/ossec-init.conf') do
    it { should exist }
    it { should be_mode 600 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
  describe file('/var/ossec/etc/ossec.conf') do
    it { should exist }
    it { should be_mode 440 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'ossec' }
  end
  describe file('/var/ossec/etc/ossec-init.conf') do
    it { should exist }
    it { should be_mode 640 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
  describe process('wazuh-integratord') do
    it { should be_running }
    its(:user) { should eq 'ossecm' }
  end
  describe process('wazuh-authd') do
    it { should be_running }
    its(:user) { should eq 'root' }
  end
  describe process('wazuh-analysisd') do
    it { should be_running }
    its(:user) { should eq 'ossec' }
  end
  describe process('wazuh-logcollector') do
    it { should be_running }
    its(:user) { should eq 'root' }
  end
  describe process('wazuh-remoted') do
    it { should be_running }
    its(:user) { should eq 'ossecr' }
  end
  describe process('wazuh-syscheckd') do
    it { should be_running }
    its(:user) { should eq 'root' }
  end
  describe process('wazuh-monitord') do
    it { should be_running }
    its(:user) { should eq 'ossec' }
  end
  describe process('nodejs') do
    it { should be_running }
    its(:user) { should eq 'root' }
  end
end
