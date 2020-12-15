#! /usr/bin/env bash
set -e

echo "Env var value: IMAGE "
echo $IMAGE
echo "Env var value: PLATFORM "
echo $PLATFORM
echo "Env var value: RELEASE"
echo $RELEASE

echo "Installing dependencies"
bundle install

cd kitchen

echo "Kitchen is creating the new instances"
kitchen test $VAGRANT_INSTANCE