#! /usr/bin/env bash
set -e

cd cookbooks/$COOKBOOK_NAME

LOG_FILE=$COOKBOOK_NAME-$OS.log

echo "Print out logs"
cat ~/wazuh-chef/.kitchen/logs/$LOG_FILE