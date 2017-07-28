#!/bin/bash

# It is assumed that this script is being executed from project root
# Usage: deploy-local.sh {source tag name} [-t {Destination image tag}]

APP_DIR=`pwd`
PROJECT_NAME="spring-loaded-docker-sample"
/bin/bash $APP_DIR/docker-build/deploy.sh -i $PROJECT_NAME:$1 -r docker-snapshot.dreamworld.solutions/spring-loaded/$PROJECT_NAME -t $3