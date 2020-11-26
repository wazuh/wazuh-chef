#
# Cookbook Name:: wazuh
# Spec:: backups
#

require 'spec_helper'

describe 'wazuh::backups' do
  context 'When all attributes are default' do
    before do
      Chef::Config[:encrypted_data_bag_secret] = 'test/data_bags/wazuh_secrets/test_data_bag_key'
      allow(Chef::EncryptedDataBagItem).to receive(:load).with('wazuh_secrets', 'api').and_return(
        '{"htpasswd_user": "ossec","htpasswd_passcode": "ossec"}'
      )
      allow(Chef::EncryptedDataBagItem).to receive(:load).with('wazuh_secrets', 'backups', 'gPTbum6NpTwIVZop5w5TzehVh/ElS52smpao+bSxKX+SRNbvnLSHwC22EZt5Q7pPamCpEBD2ycH4fEpLGCp7FCSa/RLquQNls4TiVp54DJcfbSCiRA+lFL1e7YJqX4az1I1nzj+/3RlOjpfMvEhJ9gmubGMgnXZboDG5yiv34O2CdbybpMk9wQCC11RaeJUSFuvToQlnV2jK3HvymIHivm5Ax30PvyIMj6Mpp+YlJpBj70+vvk/rLmmXCsOHHV3g6hmZJph1mJrcjQZJVM9/foqiadrFJ9HLPFn0+LMXea69q4RvPDAIl914pXnE3pJBSYL9bZuDge/krbynQNosr3yNTLs1VoV9cw2yJinYY5GoOxjFnf66nCj1bnj5uFsN8FrK7w/hi07A/EBjiOFMAGHei1+ZGKKfHVKve67CNMHsaItjgc2njyRdOWTdxAvNw7AYSF4ST8vXBJZeBQyGizd2c73Hs4B640j7PWPKBu3Tfqvig6TxSPjwN9hO/a2/pOTRSJ4RfW2cXe0ZRbUb4O6hLv4F4kXjSuiW/ckvIpSOI3G04aqvXVLBcgDiKbqwH1poqKvpRPEahu+HGAf8C4Flhm6UXrawssIEp9WC5YHMLhsu1dSx8Hi6vCXqEOWobWWuh7VhItE0ySKl/LTxB2DWn12AYs1RXkYSBL4Gz/g=').and_return(
        'development' => { 'access_key_id' => 'foo', 'secret_access_key' => 'bar', 'encryption_password' => 'zoom' }
      )
    end
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node, server|
        server.create_environment('development', {
                                    'name' => 'kitchen-env', 'description' => 'Spec Production Text Env'
                                  })
        node.chef_environment = 'development'
      end
      runner.converge(described_recipe)
    end

    it 'includes the backup::default' do
      expect(chef_run).to include_recipe 'backup::default'
    end

    it 'to install gem_package fog' do
      expect(chef_run).to install_gem_package('fog').with(
        version: '~> 1.4.0'
      )
    end
  end
end
