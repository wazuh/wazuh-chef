#
# Cookbook Name:: wazuh_elastic
# Spec:: nginx
#

require 'spec_helper'

describe 'wazuh_elastic::nginx' do
  cached(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

  before do
    allow(Chef::EncryptedDataBagItem).to receive(:load).with('wazuh_secrets', 'nginx_certificate').and_return(
      '{"nginx_certificate": "nginx_certificate"}'
    )
    allow(Chef::EncryptedDataBagItem).to receive(:load).with('wazuh_secrets', 'api').and_return(
      '{"htpasswd_user": "htpasswd_user", "htpasswd_passcode": "htpasswd_passcode"}'
    )
  end

  it 'includes the wazuh_elastic::nginx recipe' do
    expect(chef_run).to include_recipe 'wazuh_elastic::nginx'
  end

  it 'service nginx' do
    expect(chef_run).to start_service('nginx')
  end

  it 'creates a file /etc/ssl/certs/kibana-access.crt' do
    expect(chef_run).to create_file('/etc/ssl/certs/kibana-access.crt').with(
      user:   'root',
      group:  'root'
    )
  end

  it 'creates a file /etc/nginx/conf.d/kibana.htpasswd' do
    expect(chef_run).to create_file('/etc/nginx/conf.d/kibana.htpasswd').with(
      user:   'root',
      group:  'root'
    )
  end

  it 'creates a file /etc/ssl/certs/kibana-access.key' do
    expect(chef_run).to create_file('/etc/ssl/certs/kibana-access.key').with(
      user:   'root',
      group:  'root'
    )
  end

  it 'create a template default' do
    expect(chef_run).to create_template('/etc/nginx/sites-available/default').with(
      owner: 'root',
      group: 'root',
      source: 'nginx-default.erb'
    )
  end

  it 'installs nginx' do
    expect(chef_run).to install_package('nginx')
  end
end
