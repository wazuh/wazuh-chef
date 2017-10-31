require 'spec_helper'

describe 'wazuh_elk::default' do
  describe user('elasticsearch') do
    it { should exist }
  end
  describe user('logstash') do
    it { should exist }
  end
  describe file('/etc/init.d/elasticsearch') do
    it { should exist }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
  describe file('/etc/init.d/logstash') do
    it { should exist }
    it { should be_mode 775 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
  describe file('/etc/default/elasticsearch') do
    it { should exist }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
  describe file('/etc/elasticsearch') do
    it { should be_directory }
    it { should be_mode 750 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'elasticsearch' }
  end
  describe file('/usr/share/elasticsearch') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
  describe file('/var/lib/elasticsearch') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'elasticsearch' }
    it { should be_grouped_into 'elasticsearch' }
  end
  describe file('/var/log/elasticsearch') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'elasticsearch' }
    it { should be_grouped_into 'elasticsearch' }
  end
  describe file('/etc/logstash') do
    it { should be_directory }
    it { should be_mode 775 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
  describe file('/etc/logstash/conf.d') do
    it { should be_directory }
    it { should be_mode 775 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
  describe file('/var/lib/logstash') do
    it { should be_directory }
    it { should be_mode 775 }
    it { should be_owned_by 'logstash' }
    it { should be_grouped_into 'logstash' }
  end
  describe file('/var/log/logstash') do
    it { should be_directory }
    it { should be_mode 775 }
    it { should be_owned_by 'logstash' }
    it { should be_grouped_into 'root' }
  end
  describe service('elasticsearch') do
    it { should be_running }
  end
  # The following lines are commented due to known issue testing logstash
  #  describe service('logstash') do
  #    it { should be_running }
  #  end
end
