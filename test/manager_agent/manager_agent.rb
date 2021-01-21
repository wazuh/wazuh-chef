# Check agent and manager connection

describe command("netstat -vatunp | grep ossec-agentd | awk \'{print $5}\'") do
    its('stdout') { should match ('172.16.100.10:1514')} 
end

# Check agent reports logs from manager in ossec.log
describe command("cat /var/ossec/logs/ossec.log | grep \"Connected to the server\" | awk \'{print $6, $7, $8, $9, $10}\' | uniq -d") do
    its('stdout') { should match ("Connected to the server (172.16.100.10:1514/tcp).\n")}
end