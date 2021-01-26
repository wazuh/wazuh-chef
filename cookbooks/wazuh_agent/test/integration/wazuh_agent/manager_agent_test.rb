# Check agent is listening to manager

describe command("netstat -vatunp | grep ossec-agentd | awk \'{print $6}\'") do
    its('stdout') { should match ("ESTABLISHED")} 
end

# Check agent reports logs from manager in ossec.log

describe command("cat /var/ossec/logs/ossec.log | grep \"Connected to the server (#{input('manager_ip')}\/[0-9]*.[0-9]*.[0-9]*.[0-9]*:#{input('manager_port')}\/#{input('protocol')}\"") do
    its('exit_status') { should eq 0 }
end
