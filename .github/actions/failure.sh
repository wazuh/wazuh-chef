#! /usr/bin/env bash
set -e

cd cookbooks/$COOKBOOK_NAME

LOG_FILE=$COOKBOOK_NAME-$OS.log

echo "Print out logs"
cat .kitchen/logs/$LOG_FILE