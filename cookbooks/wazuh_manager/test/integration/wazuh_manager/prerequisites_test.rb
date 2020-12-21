describe package('curl') do
    it { should be_installed }
end

case os.family
when 'debian'
    describe package('apt-transport-https') do
        it { should be_installed }
    end

    describe package('lsb-release') do
        it { should be_installed }
    end

    describe package('gnupg2') do
        it { should be_installed }
    end
end
