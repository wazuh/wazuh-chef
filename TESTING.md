Test Wazuh Chef cookbooks
=========================

# Prerequisites
- Docker

# How to use
To create an environment with Wazuh Chef cookbooks just run the following command:

docker build -t . wazuh-chef:0.1
docker run -v /var/run/docker.sock:/var/run/docker.sock -it \<DOCKER_IMAGE_HASH\>

Inside, you have the wazuh-chef repository in features-cookbook branch. Important commands:

1. ``kitchen list``: list all kitchen instances 
2. ``kitchen create <suite_name>-<platform_name>``: create an instance just with OS
3. ``kitchen create <suite_name>-<platform_name>``: create an instance with all cookbooks declared
in \<suite_name\> inside a \<platfomr_name\> node
4. ``kitchen verify <suite_name>-<platform_name>``: run tests in the instance specified
5. ``kitchen destroy <suite_name>-<platform_name>``: destroy in the instance specified
6. ``kitchen login <suite_name>-<platform_name>``: login in the instance specified


