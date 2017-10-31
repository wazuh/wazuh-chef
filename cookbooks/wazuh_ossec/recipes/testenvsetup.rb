# Define hostnames needed for testing

hostsfile_entry '172.16.10.11' do
  hostname  'elk.wazuh-test.com'
  action    :create
end

hostsfile_entry '172.16.10.10' do
  hostname  'manager.wazuh-test.com'
  action    :create
end
