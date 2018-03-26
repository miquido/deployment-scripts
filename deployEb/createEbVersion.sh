#!/bin/bash

# Required environment variables:
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION
# PROJECT_NAME
# S3_BUCKET
# EB_APPLICATION_NAME

set -o errexit
set -o nounset
set -o pipefail

if [ $# -lt 1 \
    -o -z "$AWS_ACCESS_KEY_ID" \
    -o -z "$AWS_SECRET_ACCESS_KEY" \
    -o -z "$AWS_DEFAULT_REGION" \
    -o -z "$PROJECT_NAME" \
    -o -z "$S3_BUCKET" \
    -o -z "$EB_APPLICATION_NAME" \
    ] ; then
  echo "Usage: createEbVersion.sh <version>"
  echo "Environment variables which must be set:"
  echo "  AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION, PROJECT_NAME, S3_BUCKET, EB_APPLICATION_NAME"
  exit 1
fi
echo CreateEBVersion

VERSION=$1
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR=$SCRIPT_DIR/../..
DEPLOYMENT_SCRIPTS_DIR=$PROJECT_DIR/deployment-scripts

### Upload to ECR Docker registry
cd $DEPLOYMENT_SCRIPTS_DIR
EB_VERSION_PACKAGE=$PROJECT_NAME-$VERSION.zip
S3_KEY=preversions/$EB_VERSION_PACKAGE

utils/aws elasticbeanstalk create-application-version \
                       --application-name "$EB_APPLICATION_NAME" \
                       --version-label "$VERSION" \
                       --source-bundle S3Bucket="$S3_BUCKET",S3Key="$S3_KEY"


