#
# Cookbook Name:: wazuh_elastic
# Spec:: logstash
#

require 'spec_helper'

describe 'wazuh_elastic::logstash' do
  cached(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

  before do
    allow(Chef::EncryptedDataBagItem).to receive(:load).with('wazuh_secrets', 'logstash_certificate').and_return(
      '{"logstash_certificate": "logstash_certificate"}'
    )
  end

  it 'includes the wazuh_elastic::logstash recipe' do
    expect(chef_run).to include_recipe 'wazuh_elastic::logstash'
  end

  it 'service logstash' do
    expect(chef_run).to start_service('logstash')
  end

  it 'creates a file /etc/logstash/logstash-forwarder.key' do
    expect(chef_run).to create_file('/etc/logstash/logstash-forwarder.key').with(
      user:   'root',
      group:  'root'
    )
  end

  it 'creates a file /etc/logstash/logstash-forwarder.crt' do
    expect(chef_run).to create_file('/etc/logstash/logstash-forwarder.crt').with(
      user:   'root',
      group:  'root'
    )
  end

  it 'create a template elastic-ossec-template.json' do
    expect(chef_run).to create_template('/etc/logstash/elastic-ossec-template.json').with(
      owner:  'root',
      group:  'root',
      source: 'elastic-ossec-template.json.erb'
    )
  end

  it 'create a template 01-ossec.conf' do
    expect(chef_run).to create_template('/etc/logstash/conf.d/01-ossec.conf').with(
      owner:  'root',
      group:  'root',
      source: '01-ossec.conf.erb'
    )
  end

  it 'installs logstash' do
    expect(chef_run).to install_package('logstash')
  end
end
