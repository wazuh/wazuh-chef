# frozen_string_literal: true

describe 'filebeat::repository' do
    case os.family
    when 'debian'
        describe apt('http://packages.wazuh.com/4.x/apt/') do
            it { should exist }
        end
    when 'redhat', 'suse'
        describe yum.repo('http://packages.wazuh.com/4.x/yum/') do
            it { should exist }
        end 
    end
end