# Check agent is listening to manager

describe command("netstat -vatunp | grep ossec-agentd | awk \'{print $5}\'") do
    its('stdout') { should match ("#{input('manager_ip')}:1514")} 
end

# Check agent reports logs from manager in ossec.log

describe command("cat /var/ossec/logs/ossec.log | grep \"Connected to the server\" | awk \'{print $6, $7, $8, $9, $10}\' | uniq -d") do
    before do
        puts "Sleeping 10 seconds..."
        sleep 10
    end
    its('stdout') { should match ("Connected to the server (#{input('manager_ip')}:1514/tcp).\n")}
end