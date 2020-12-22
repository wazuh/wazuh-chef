Test Wazuh Chef cookbooks
=========================

# Global prerequisistes
- Ruby
- ChefDK

There are two ways of creating a chef environment and tests cookbooks depending on what driver to use:
- [kitchen-vagrant](https://github.com/test-kitchen/kitchen-vagrant)
- [kitchen-dokken](https://github.com/test-kitchen/kitchen-dokken)

Kitchen-vagrant
===============

## Prerequisites
- Vagrant
- Virtualbox

## Hot to use?
First install dependancies: ``bundle config set without 'dokken'``

Then go to ``wazuh-chef/kitchen-vagrant`` folder and execute kitchen commands.

Kitchen dokken
==============

## Prerequisites
- Docker

## How to use?
First install dependancies: ``bundle config set without 'vagrant'``

Then execute kithcen commands.

Kitchen command
===============

Kitchen commands To create an environment with Wazuh Chef cookbooks:

1. ``kitchen list``: list all kitchen instances 
2. ``kitchen create <suite_name>-<platform_name>``: create an instance just with a \<platform_name\> node initialized.
3. ``kitchen create <suite_name>-<platform_name>``: create an instance with all cookbooks declared
in \<suite_name\> inside a \<platform_name\> node
4. ``kitchen verify <suite_name>-<platform_name>``: run tests in the instance specified
5. ``kitchen destroy <suite_name>-<platform_name>``: destroy in the instance specified
6. ``kitchen login <suite_name>-<platform_name>``: login in the instance specified


