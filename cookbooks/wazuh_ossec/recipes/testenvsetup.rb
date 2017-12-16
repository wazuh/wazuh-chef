# Define hostnames needed for testing

<<<<<<< HEAD
hostsfile_entry '172.16.10.11' do
  hostname  'elk.wazuh-test.com'
  action    :create
end

hostsfile_entry '172.16.10.10' do
  hostname  'manager.wazuh-test.com'
=======
hostsfile_entry '172.16.10.10' do
  hostname  'manager-master.wazuh-test.com'
  action    :create
end

hostsfile_entry '172.16.10.11' do
  hostname  'manager-client.wazuh-test.com'
  action    :create
end

hostsfile_entry '172.16.10.12' do
  hostname  'elk.wazuh-test.com'
>>>>>>> d3e691bba7f9a6a500c6722eb8e57a4110600cbb
  action    :create
end
