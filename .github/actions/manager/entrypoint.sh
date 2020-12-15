#! /usr/bin/env bash
set -e

echo "Env var value: IMAGE "
echo $IMAGE
echo "Env var value: PLATFORM "
echo $PLATFORM
echo "Env var value: RELEASE"
echo $RELEASE

cd kitchen

echo "Installing dependencies"
bundle install

echo "Install vagrant"
git clone https://github.com/dotcloud/docker.git
cd vagrant
bundle install

echo "Kitchen is creating the new instances"
kitchen test $VAGRANT_INSTANCE