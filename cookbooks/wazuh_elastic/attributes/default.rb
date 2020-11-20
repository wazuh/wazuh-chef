=begin
This attributes define which environment to use:
    - Opendistroforelasticsearch
    - Elastic Stack
Neither of both variables can be assigned to the same value. One has to be set to "true" and the
other one to "false".
Both are checked inside recipes/default.rb recipe 
=end
default['wazuh-elastic']['elasticsearch'] = false
default['wazuh-elastic']['odfe'] = true

# Setup in role
default['wazuh-elastic']['ip'] = "0.0.0.0"
default['wazuh-kibana']['ip'] = "0.0.0.0"

default['wazuh-elastic']['config_path'] = "/etc/elasticsearch"
default['wazuh-elastic']['plugins_path'] = "/usr/share/elasticsearch/plugins"