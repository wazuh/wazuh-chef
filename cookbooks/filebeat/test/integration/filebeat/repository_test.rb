# frozen_string_literal: true

case os.family
when 'debian'
    describe apt('https://artifacts.elastic.co/packages/7.x/apt') do
        it { should exist }
        it { should be_enabled }
    end
when 'redhat'
    describe yum.repo('elastic') do
        it { should exist }
        it { should be_enabled }
    end 
end