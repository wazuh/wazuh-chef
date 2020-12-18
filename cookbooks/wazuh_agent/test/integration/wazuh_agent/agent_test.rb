describe package('wazuh-agent') do
    it { should be_installed }
end

describe service('wazuh-agent') do
    it { should be_running }
end