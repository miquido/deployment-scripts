#!/usr/bin/env bash

if [ $# -lt 2 ] ; then
  echo "Usage: buildAndDeploy.sh <version number> <env>"
  exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
set -o errexit
$SCRIPT_DIR/01-prebuild.sh $1 $2
$SCRIPT_DIR/02-build.sh $1 $2
$SCRIPT_DIR/03-buildDocker.sh $1 $2
$SCRIPT_DIR/04-deploy.sh $1 $2




