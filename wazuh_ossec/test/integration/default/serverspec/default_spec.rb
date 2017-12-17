require 'spec_helper'
require 'common_ossec_tests'

describe 'wazuh_ossec::default' do
  # This is just a sample integration test
  describe file('/etc/passwd') do
    it { should be_file }
  end
end
