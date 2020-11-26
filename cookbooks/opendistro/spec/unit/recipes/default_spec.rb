#
# Cookbook Name:: wazuh_elastic
# Spec:: default
#

require 'spec_helper'

describe 'wazuh_elastic::default' do
  cached(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

  it 'does not raise an exception' do
    stub_command('dpkg -s oracle-java8-installer').and_return(true)
    expect { chef_run }.to_not raise_error
  end

  before do
    allow(Chef::EncryptedDataBagItem).to receive(:load).with('wazuh_secrets', 'nginx_certificate').and_return('{"nginx_certificate": "nginx_certificate"}')
    allow(Chef::EncryptedDataBagItem).to receive(:load).with('wazuh_secrets', 'logstash_certificate').and_return('{"logstash_certificate": "logstash_certificate"}')
    allow(Chef::EncryptedDataBagItem).to receive(:load).with('wazuh_secrets', 'api').and_return('{"htpasswd_user": "htpasswd_user", "htpasswd_passcode": "htpasswd_passcode"}')
  end

  it 'includes the wazuh_elastic::default recipe' do
    expect(chef_run).to include_recipe 'wazuh_elastic::default'
  end
end
