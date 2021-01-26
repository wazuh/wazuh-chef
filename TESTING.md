# Test Wazuh Chef cookbooks

## Global prerequisistes
- [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
- [Chef Workstation](https://downloads.chef.io/products/workstation)

There are two ways of creating a chef environment and tests cookbooks depending 
on what driver to use:

- [kitchen-vagrant](https://github.com/test-kitchen/kitchen-vagrant)
- [kitchen-dokken](https://github.com/test-kitchen/kitchen-dokken)

## Kitchen-vagrant

### Prerequisites
- [Vagrant](https://www.vagrantup.com/docs/installation)
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
- Depependencies: 

```bash
bundle config set --local without 'dokken'
bundle install
```

## Kitchen dokken

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/)
- Depependencies: 

```bash
bundle config set --local without 'vagrant'
bundle install
```

## How to use?

Once you select the driver and install all the dependencies, you can create your first node by running the following Kitchen CI commands:

1. ``kitchen list``: list all kitchen instances in the form of \<suite_name\> and
\<platform_name\> joined with a hyphen
2. ``kitchen create <suite_name>-<platform_name>``: create an instance just with a \<platform_name\> node initialized.
3. ``kitchen create <suite_name>-<platform_name>``: create an instance with all cookbooks declared
in \<suite_name\> inside a \<platform_name\> node
4. ``kitchen verify <suite_name>-<platform_name>``: run tests in the instance specified
5. ``kitchen destroy <suite_name>-<platform_name>``: destroy in the instance specified
6. ``kitchen login <suite_name>-<platform_name>``: login in the instance specified

By defaul, kitchen will look for a ``[.]kitchen.y[a]ml`` file.

In case you want to use **dokken** as your driver, you need to specify *kitchen.dokken.yml* file as the default kitchen conf file by overriding **KITCHEN_YAML** env variable, 
e.g.:

```bash
KITCHEN_YAML="kitchen.dokken.yml" kitchen list
```
