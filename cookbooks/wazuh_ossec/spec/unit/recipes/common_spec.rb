#
# Cookbook Name:: wazuh_ossec
# Spec:: common
#

require 'spec_helper'
describe 'wazuh_ossec::common' do
  context 'When all attributes are default, on an unspecified platform' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'includes the wazuh_ossec::common recipe' do
      expect(chef_run).to include_recipe 'wazuh_ossec::common'
    end

    it 'creates a file /var/ossec/etc/ossec.conf' do
      expect(chef_run).to create_file('/var/ossec/etc/ossec.conf').with(
        user:   'root',
        group:  'ossec'
      )
    end

    it 'creates a file /var/ossec/etc/shared/agent.conf' do
      expect(chef_run).to create_file('/var/ossec/etc/shared/agent.conf').with(
        user:   'root',
        group:  'ossec'
      )
    end

    it 'installs a chef_gem gyoku' do
      expect(chef_run).to install_chef_gem('gyoku')
      expect(chef_run).to_not install_chef_gem('non_gyoku')
    end

    it 'runs a ruby_block when specifying the identity attribute' do
      expect(chef_run).to run_ruby_block('ossec install_type')
    end
  end
end
