#!/bin/bash

# Required environment variables:
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION
# PROJECT_NAME
# DOCKER_REGISTRY_HOST
# S3_BUCKET
# EB_APPLICATION_NAME

set -o errexit
set -o nounset
set -o pipefail

if [ $# -lt 1 ] ; then
  echo "Usage: deployOnEb.sh <version> <EB environment>"
  exit 1
fi

VERSION=$1
EB_ENVIRONMENT=$2
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR=$SCRIPT_DIR/../..
DEPLOYMENT_SCRIPTS_DIR=$PROJECT_DIR/deployment-scripts
cd $DEPLOYMENT_SCRIPTS_DIR/deployEb

########## Deployment steps ###################

### Upload to ECR Docker registry
./pushToEcr.sh $VERSION

### Prepare AWS EB application version
./buildEbVersion.sh $PROJECT_NAME "$DOCKER_REGISTRY_HOST/$PROJECT_NAME" $VERSION

### Upload AWS EB application version
./uploadEbVersion.sh $VERSION

### Create AWS EB application version
./createEbVersion.sh $VERSION

### Upgrade AWS EB application version on DEV environment
./deployEbVersionOnEnv.sh $VERSION $EB_ENVIRONMENT

