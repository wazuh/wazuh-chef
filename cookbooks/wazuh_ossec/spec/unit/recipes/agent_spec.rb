#
# Cookbook Name:: wazuh_ossec
# Spec:: agent

require 'spec_helper'

describe 'wazuh_ossec::agent' do
  context 'When all attributes are default, on an unspecified platform' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'includes the wazuh_ossec::install_agent recipe' do
      expect(chef_run).to include_recipe 'wazuh_ossec::install_agent'
    end

    it 'installs ossec-hids-agent' do
      expect(chef_run).to install_package('ossec-hids-agent')
    end

    it 'service restart ossec' do
      expect(chef_run).to start_service('ossec')
    end

    it 'reloads a ohai reload lsb' do
      expect(chef_run).to reload_ohai('reload lsb')
      expect(chef_run).to_not reload_ohai('not_default_action')
    end
  end
end
