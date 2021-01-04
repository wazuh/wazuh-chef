describe package('wazuh-agent') do
    it { should be_installed }
end

describe service('wazuh-agent') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
end