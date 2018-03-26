#!/bin/bash

# Required environment variables:
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION
# EB_APPLICATION_NAME

set -o errexit
set -o nounset
set -o pipefail

if [ $# -lt 2 \
    -o -z "$AWS_ACCESS_KEY_ID" \
    -o -z "$AWS_SECRET_ACCESS_KEY" \
    -o -z "$AWS_DEFAULT_REGION" \
    -o -z "$PROJECT_NAME" \
    -o -z "$S3_BUCKET" \
    -o -z "$EB_APPLICATION_NAME" \
    ] ; then
  echo "Usage: deployEbVersionOnEnv.sh <version> <environment name>"
  echo "Environment variables which must be set:"
  echo "  AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION, EB_APPLICATION_NAME"
  exit 1
fi
echo DeployEBVersionOnDev

VERSION=$1
EB_ENVIRONMENT_NAME=$2
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR=$SCRIPT_DIR/../..
DEPLOYMENT_SCRIPTS_DIR=$PROJECT_DIR/deployment-scripts

### Upload to ECR Docker registry
cd $PROJECT_DIR

$DEPLOYMENT_SCRIPTS_DIR/utils/aws elasticbeanstalk update-environment \
  --application-name "$EB_APPLICATION_NAME" \
  --environment-name "$EB_ENVIRONMENT_NAME" \
  --version-label "$VERSION" \
  --option-settings Namespace=aws:elasticbeanstalk:application:environment,OptionName=VERSION,Value=$VERSION
