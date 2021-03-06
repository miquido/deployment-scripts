#!/bin/bash

# Accessible environment variables:
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION
# PROJECT_NAME
# DOCKER_REGISTRY_HOST
# S3_BUCKET
# EB_APPLICATION_NAME

# VERSION_NUMBER
# ENV - eg. dev, stage, prod
# VERSION - calculated VERSION, usually 1-dev or just 1

# PROJECT_DIR
# DEPLOYMENT_SCRIPTS_DIR
# DEPLOYMENT_CONF_DIR

# Prepare dependencies
BUILD_DIR=$PROJECT_DIR/build
BUILD_ENV_FILE=$BUILD_DIR/build.env
mkdir -p $BUILD_DIR
env > $BUILD_ENV_FILE
docker run --env-file $BUILD_ENV_FILE -v $PROJECT_DIR:/usr/src/app -w /usr/src/app -t node bash -c "npm run build:$ENV; chown -R ${UID}:${GROUPS} ."
