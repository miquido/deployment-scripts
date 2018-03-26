#!/bin/bash

# Required environment variables:
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION
# PROJECT_NAME
# DOCKER_REGISTRY_HOST

set -o errexit
set -o nounset
set -o pipefail

if [ $# -lt 1 \
    -o -z "$AWS_ACCESS_KEY_ID" \
    -o -z "$AWS_SECRET_ACCESS_KEY" \
    -o -z "$AWS_DEFAULT_REGION" \
    -o -z "$PROJECT_NAME" \
    -o -z "$DOCKER_REGISTRY_HOST" \
    ] ; then
  echo "Usage: pushToEcr.sh <version>"
  echo "Environment variables which must be set:"
  echo "  AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION, PROJECT_NAME, DOCKER_REGISTRY_HOST"
  exit 1
fi
echo PushToEcr

VERSION=$1
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

### Upload to ECR Docker registry
eval $($SCRIPT_DIR/../utils/aws ecr get-login --no-include-email --region $AWS_DEFAULT_REGION)
docker tag $PROJECT_NAME $DOCKER_REGISTRY_HOST/${PROJECT_NAME}:$VERSION
docker push $DOCKER_REGISTRY_HOST/${PROJECT_NAME}:$VERSION



