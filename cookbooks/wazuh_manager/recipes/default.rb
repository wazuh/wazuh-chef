include_recipe 'apt::default'
include_recipe 'wazuh_manager::prerequisites'
include_recipe 'wazuh_manager::repository'
include_recipe 'wazuh_manager::manager'