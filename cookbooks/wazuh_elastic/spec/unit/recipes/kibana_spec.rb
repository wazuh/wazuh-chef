#
# Cookbook Name:: wazuh_elastic
# Spec:: kibana
#

require 'spec_helper'

describe 'wazuh_elastic::kibana' do
  cached(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

  before do
    allow(Chef::EncryptedDataBagItem).to receive(:load).with('wazuh_secrets', 'logstash_certificate').and_return(
      '{"logstash_certificate": "logstash_certificate"}'
    )
  end

  it 'includes the wazuh_elastic::kibana recipe' do
    expect(chef_run).to include_recipe 'wazuh_elastic::kibana'
  end

  it 'installs python-requests' do
    expect(chef_run).to install_package('python-requests')
  end

  it 'create a template /tmp/wazuh_kibana_installer.py' do
    expect(chef_run).to create_template('/tmp/wazuh_kibana_installer.py').with(
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0777',
      :source => 'wazuh_kibana_installer.py.erb'
    )
  end

  it 'create a template kibana.yml' do
    expect(chef_run).to create_template('/opt/kibana/config/kibana.yml').with(
      :owner  => 'root',
      :group  => 'root',
      :source => 'kibana.yml.erb'
    )
  end

  it 'service kibana' do
    expect(chef_run).to start_service('kibana')
  end

  it 'installs kibana' do
    expect(chef_run).to install_package('kibana')
  end
end
