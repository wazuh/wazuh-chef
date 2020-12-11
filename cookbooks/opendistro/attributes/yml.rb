# frozen_string_literal: true

# Elasticsearch-oss configuration file

default['elastic']['yml'] = {
  'network' => {
    'host' => '0.0.0.0'
  },
  'http' => {
    'port' => 9200
  },
  'node' => {
    'name' => 'odfe-node-1'
  },
  'cluster' => {
    'initial_master_nodes' => [
      'odfe-node-1'
    ]
  }
}

# Kibana-oss configuration file

default['kibana']['yml'] = {
  'server' => {
    'host' => '0.0.0.0',
    'port' => 443
  },
  'elasticsearch' => {
    'hosts' => [
      "https://#{node['elastic']['yml']['network']['host']}:#{node['elastic']['yml']['http']['port']}"
    ]
  }
}

# Searchguard configuraion file

default['search_guard']['yml'] =
  {
    'nodes' => {
      'elasticsearch' => {
        'ip' => [
          (node['elastic']['yml']['network']['host']).to_s
        ]
      },
      'kibana' => {
        'ip' => [
          (node['kibana']['yml']['server']['host']).to_s
        ]
      }
    }
  }
