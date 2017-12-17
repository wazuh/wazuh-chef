#
# Cookbook Name:: wazuh_filebeat
# Spec:: manager
#

require 'spec_helper'

describe 'wazuh_filebeat::default' do
  cached(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

  before do
    allow(Chef::EncryptedDataBagItem).to receive(:load).with('wazuh_secrets', 'logstash_certificate').and_return(
      '{"logstash_certificate": "ossec"}'
    )
  end

  it 'includes the wazuh_filebeat:default recipe' do
    expect(chef_run).to include_recipe 'wazuh_filebeat::default'
  end

  it 'installs filebeat' do
    expect(chef_run).to install_package('filebeat')
  end

  it 'service restart filebeat' do
    expect(chef_run).to start_service('filebeat')
  end

  it 'creates template for /etc/filebeat/filebeat.yml' do
    expect(chef_run).to create_template('/etc/filebeat/filebeat.yml').with(
      mode:   '0640',
      user:   'root',
      group:  'root',
      source: 'filebeat.yml.erb'
    )
  end

  it 'creates a file /etc/filebeat/logstash_certificate.crt' do
    expect(chef_run).to create_file('/etc/filebeat/logstash_certificate.crt').with(
      user:   'root',
      group:  'root'
    )
  end

end
