default['ossec']['centralized_configuration']['enabled']  = 'no'
default['ossec']['centralized_configuration']['path']     = '/var/ossec/etc/shared/default'

# Example of configuration to include in agent.conf

# <agent_config os="Linux">
#     <localfile>
#         <location>/var/log/linux.log</location>
#         <log_format>syslog</log_format>
#     </localfile>
# </agent_config>

# Would require to be be declared like:

# default['ossec']['centralized_configuration']['conf']['agent_config']= [
#     {   "@os" => "Linux",
#         "localfile" => {
#             "location" => "/var/log/linux.log",
#             "log_format" => "syslog"
#         }
#     }
# ]
