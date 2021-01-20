# Check agent and manager connection

describe command("netstat -vatunp | grep ossec-agentd | awk \'{print $5}\'") do
    its('stdout') { should match ('172.16.100.10:1514')} 
end
