#!/usr/bin/env bash

if [ $# -lt 2 ] ; then
  echo "Usage: 10-prebuild.sh <version number> <env>"
  exit 1
fi
export VERSION_NUMBER=$1
export ENV=$2

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
export PROJECT_DIR=$SCRIPT_DIR/..
export DEPLOYMENT_SCRIPTS_DIR=$SCRIPT_DIR
export DEPLOYMENT_CONF_DIR=$PROJECT_DIR/deployment-conf

. $DEPLOYMENT_SCRIPTS_DIR/init/init.sh

hook=$(evalHook "prebuild" $HOOK_PREBUILD)
set -o errexit
set -o nounset
set -o pipefail
. $hook




