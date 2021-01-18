Test Wazuh Chef cookbooks
=========================

# Global prerequisistes
- [Ruby](https://www.ruby-lang.org/es/documentation/installation/)
- [Chef Workstation](https://downloads.chef.io/products/workstation)
- Install dependancies: ``bundle install``

[Kitchen-vagrant](https://github.com/test-kitchen/kitchen-vagrant)
===============

## Prerequisites
- Vagrant
- Virtualbox

## Kitchen commands

Commands to create an environment with Wazuh Chef cookbooks:

1. ``kitchen list``: list all kitchen instances  
2. ``kitchen create <instance>``: create an instance.
3. ``kitchen converge <instance>``: deploy an instance
4. ``kitchen verify <instance>``: run tests in specified instance
5. ``kitchen destroy <instance>``: destroy specified instance
6. ``kitchen login <instance>``: login specified instance

There are 2 types of environments:

1. **ODFE single node**: create full single node with ODFE
2. **ELK single node**: create full single node with ELK
