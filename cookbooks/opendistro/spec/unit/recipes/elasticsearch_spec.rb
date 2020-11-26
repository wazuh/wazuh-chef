#
# Cookbook Name:: wazuh_elastic
# Spec:: elasticsearch
#

require 'spec_helper'

describe 'wazuh_elastic::elasticsearch' do
  cached(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

  it 'includes the wazuh_elastic::elasticssearch recipe' do
    expect(chef_run).to include_recipe 'wazuh_elastic::elasticsearch'
  end

  it 'service elasticsearch' do
    expect(chef_run).to start_service('elasticsearch')
  end

  it 'create a template elasticsearch.yml' do
    expect(chef_run).to create_template('/etc/elasticsearch/elasticsearch.yml').with(
      :owner  => 'root',
      :group  => 'elasticsearch',
      :source => 'elasticsearch.yml.erb'
    )
  end
end
