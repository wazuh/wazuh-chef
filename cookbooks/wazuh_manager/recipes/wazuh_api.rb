

case node['platform']
when 'debian', 'ubuntu'

  bash 'Install nodejs' do
    code <<-EOH
      cd /tmp &&
      curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
      EOH
    not_if { ::File.exist?('/etc/apt/sources.list.d/nodesource.list') }
  end

when 'redhat', 'centos', 'fedora'

  bash 'Install nodejs' do
    code <<-EOH
      cd /tmp &&
      curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
      EOH
    not_if { ::File.exist?('/etc/yum.repos.d/nodesource-el.repo') }
  end

end

package ['nodejs', 'wazuh-api']


api_keys = Chef::EncryptedDataBagItem.load('wazuh_secrets', 'api')

file "#{node['ossec']['dir']}/api/configuration/auth/user" do
  mode '0650'
  owner 'root'
  group 'root'
  content "#{api_keys['htpasswd_user']}:#{api_keys['htpasswd_passcode']}"
  action :create
  notifies :restart, 'service[wazuh-api]', :delayed
end

service 'wazuh-api' do
  supports restart: true
  action [:enable, :start]
end
