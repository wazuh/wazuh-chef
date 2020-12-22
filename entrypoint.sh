#! /usr/bin/env bash

RESPOSITORY="wazuh-chef"
BRANCH="feature-cookbooks"

echo "Clone wazuh-chef repository"
git clone https://github.com/wazuh/${RESPOSITORY}.git
cd ${RESPOSITORY}
git checkout ${BRANCH}

echo "List kitchen instances"
kitchen list

/bin/bash