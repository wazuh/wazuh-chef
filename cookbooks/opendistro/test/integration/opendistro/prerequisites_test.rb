# frozen_string_literal: true

describe 'elastic-stack::prerequisites' do
  describe package('curl') do
    it { should be_installed }
  end

  describe package('unzip') do
    it { should be_installed }
  end

  describe package('wget') do
    it { should be_installed }
  end

  case os.family
  when 'debian'
    describe package('apt-transport-https') do
      it { should be_installed }
    end

    describe package('software-properties-common') do
      it { should be_installed }
    end

    describe package('libcap2-bin') do
      it { should be_installed }
    end

    describe package('openjdk-11-jdk') do
      it { should be_installed }
    end

  when 'redhat'
    describe package('libcap') do
      it { should be_installed }
    end

    describe package('java-11-openjdk') do
      it { should be_installed }
    end
  when 'suse'
    describe package('libcap2') do
      it { should be_installed }
    end

    describe package('java-11-openjdk') do
      it { should be_installed }
    end
  end
end
