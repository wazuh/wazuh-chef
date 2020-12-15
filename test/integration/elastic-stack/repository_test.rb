# frozen_string_literal: true

describe 'elastic-stack::repository' do
  case os.family
  when 'debian'
    describe apt('https://artifacts.elastic.co/packages/7.x/apt') do
      it { should exist }
      it { should be_enabled }
    end
  when 'redhat'
    describe yum.repo('https://artifacts.elastic.co/packages/7.x/yum') do
      it { should exist }
      it { should be_enabled }
    end
  when 'suse'
    describe yum.repo('https://artifacts.elastic.co/packages/7.x/yum') do
      it { should exist }
      it { should be_enabled }
    end
  end
end