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

echo "Kitchen is creating the new instances"
bundle exec kitchen create $VAGRANT_INSTANCE