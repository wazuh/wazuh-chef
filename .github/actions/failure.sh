#! /usr/bin/env bash
set -e

case $OS in
    ubuntu-18.04)
        OS_NAME=ubuntu-1804
        ;;
    ubuntu-20.04)
        OS_NAME=ubuntu-2004
        ;;
    *)
        OS_NAME=$OS
        ;;
esac

LOG_FILE=elastic-stack-$OS_NAME.log
echo "Print out logs"
cat .kitchen/logs/$LOG_FILE