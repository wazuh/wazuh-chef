#! /usr/bin/env bash
set -e

echo "Cookbook to test: "
echo $COOKBOOK_NAME

cd cookbooks/$COOKBOOK_NAME

echo "Installing dependencies"
bundle install

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

echo "Test cookbook with kitchen... (create, converge, verify and destroy)"
kitchen test $COOKBOOK_NAME-$OS_NAME