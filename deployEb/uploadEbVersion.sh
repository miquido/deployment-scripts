#!/bin/bash

# Required environment variables:
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION
# PROJECT_NAME
# S3_BUCKET

set -o errexit
set -o nounset
set -o pipefail

if [ $# -lt 1 \
    -o -z "$AWS_ACCESS_KEY_ID" \
    -o -z "$AWS_SECRET_ACCESS_KEY" \
    -o -z "$AWS_DEFAULT_REGION" \
    -o -z "$PROJECT_NAME" \
    -o -z "$S3_BUCKET" \
    ] ; then
  echo "Usage: uploadEbVersion.sh <version>"
  echo "Environment variables which must be set:"
  echo "  AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION, PROJECT_NAME, S3_BUCKET"
  exit 1
fi
echo UploadEbVersion

VERSION=$1
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR=$SCRIPT_DIR/../..
DEPLOYMENT_SCRIPTS_DIR=$PROJECT_DIR/deployment-scripts
AWS_EB_VERSION_BUILD_DIR=$PROJECT_DIR/build/aws-eb-version

### Upload to ECR Docker registry
cd $AWS_EB_VERSION_BUILD_DIR
EB_VERSION_PACKAGE=$PROJECT_NAME-$VERSION.zip
S3_KEY=preversions/$EB_VERSION_PACKAGE
$DEPLOYMENT_SCRIPTS_DIR/utils/aws s3 cp $EB_VERSION_PACKAGE s3://$S3_BUCKET/$S3_KEY



