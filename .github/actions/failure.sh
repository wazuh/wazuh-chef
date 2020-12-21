#! /usr/bin/env bash
set -e

LOG_FILE=$COOKBOOK_NAME-$OS.log

echo "Print out logs"
cat ~/wazuh-chef/.kitchen/logs/$LOG_FILE