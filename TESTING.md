Test Wazuh Chef cookbooks
=========================

# Prerequisites
- Vagrant
- Virtualbox

# How to use
Kitchen commands To create an environment with Wazuh Chef cookbooks:

1. ``kitchen list``: list all kitchen instances 
2. ``kitchen create <suite_name>-<platform_name>``: create an instance just with OS
3. ``kitchen create <suite_name>-<platform_name>``: create an instance with all cookbooks declared
in \<suite_name\> inside a \<platfomr_name\> node
4. ``kitchen verify <suite_name>-<platform_name>``: run tests in the instance specified
5. ``kitchen destroy <suite_name>-<platform_name>``: destroy in the instance specified
6. ``kitchen login <suite_name>-<platform_name>``: login in the instance specified


