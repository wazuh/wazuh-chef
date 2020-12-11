# frozen_string_literal: true

describe 'elastic-stack::prerequisites' do
  describe package('curl') do
    it { should be_installed }
  end

  case os.family
  when 'debian'
    describe package('apt-transport-https') do
      it { should be_installed }
    end
  when 'redhat'
    describe package('libcap') do
      it { should be_installed }
    end
  when 'suse'
    describe package('libcap2') do
      it { should be_installed }
    end
  end
end
