# frozen_string_literal: true

case os.family
when 'debian'
    describe apt('http://packages.wazuh.com/4.x/apt/') do
        it { should exist }
        it { should be_enabled }
    end
when 'redhat', 'suse'
    describe yum.repo('wazuh') do
        it { should exist }
        it { should be_enabled }
    end 
end