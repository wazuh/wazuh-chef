#! /usr/bin/env bash
set -e

echo "Cookbook to test: ${COOKBOOK_NAME}"

echo "Test cookbook with kitchen... (create, converge, verify and destroy)"
kitchen test $COOKBOOK_NAME-$OS