#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

if [ $# -lt 2 ] ; then
  echo "Usage: buildEBVersion.sh <project name> <docker registry> <version>"
  exit 1
fi
echo BuildEBVersion

PROJECT_NAME=$1
DOCKER_REGISTRY=$2
VERSION=$3
DOCKER_TAG=$DOCKER_REGISTRY:$VERSION

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR=$SCRIPT_DIR/../..
DEPLOYMENT_SCRIPTS_DIR=$PROJECT_DIR/deployment-scripts
DEPLOYMENT_CONF_DIR=$PROJECT_DIR/deployment-conf

AWS_EB_VERSION_BUILD_DIR=$PROJECT_DIR/build/aws-eb-version

rm -rf $AWS_EB_VERSION_BUILD_DIR 2> /dev/null
mkdir -p $AWS_EB_VERSION_BUILD_DIR/package

cat $DEPLOYMENT_CONF_DIR/awseb/Dockerrun.aws.json | sed "s~{{APPLICATION_IMAGE}}~$DOCKER_TAG~g" > $AWS_EB_VERSION_BUILD_DIR/package/Dockerrun.aws.json

cd $AWS_EB_VERSION_BUILD_DIR/package
zip -r $AWS_EB_VERSION_BUILD_DIR/$PROJECT_NAME-$VERSION.zip .



