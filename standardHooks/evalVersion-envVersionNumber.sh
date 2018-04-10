#!/bin/bash

# Accessible environment variables:
# VERSION_NUMBER
# ENV - eg. dev, stage, prod
export VERSION=$ENV-$VERSION_NUMBER
