#! /usr/bin/env bash
set -e

echo "Cookbook to test: "
echo $COOKBOOK_NAME

cd cookbooks/$COOKBOOK_NAME

echo "Installing dependencies"
bundle install

case $OS in
    ubuntu-18.04)
        $OS=ubuntu-1804
        ;;
    ubuntu-20.04)
        $OS=ubuntu-2004
        ;;
    *)
        echo -n "Not Ubuntu OS"
        ;;
esac

echo "Test cookbook with kitchen... (create, converge, verify and destroy)"
kitchen test $COOKBOOK_NAME-$OS