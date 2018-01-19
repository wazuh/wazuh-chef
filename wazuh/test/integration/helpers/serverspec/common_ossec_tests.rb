
describe 'wazuh::common' do
  describe package('chef') do
    it { should be_installed }
  end
  describe user('ossec') do
    it { should exist }
  end
  describe group('ossec') do
    it { should exist }
  end
  describe file('/var/ossec') do
    it { should be_directory }
    it { should be_mode 550 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'ossec' }
  end
  describe file('/var/ossec/etc') do
    it { should be_directory }
    it { should be_mode 550 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'ossec' }
  end
end
