#!/bin/bash

set -e


# Set the version that is getting built

# Set the Docker registry to Use
REGISTRY="docker.io/davidmacpherson"
IMAGE="cust-auth-plugin"
VERSION="0.0.0-devel"
CONTAINER_TAG=$REGISTRY/$IMAGE:$VERSION

ACTION_COMPILE=true
ACTION_BUILD=true
ACTION_PUSH=true

while test $# -gt 0; do
  case "$1" in
    --skip-compile)
        ACTION_COMPILE=false
        shift
    ;;
    --skip-build)
        ACTION_BUILD=false
        shift
    ;;
    --skip-push)
        ACTION_PUSH=false
        shift
    ;;
    *)
        break
    ;;      
  esac
done

####################################################
#####  Functions
####################################################


# This will Build a container 
# Args
#   $1 - Container Tag
#   $2 - Docker File
#   $3 - Docker build additional arguments
#   $4 - Docker build additional arguments
#   $5 - Docker build additional arguments
function Build_Container(){
    TAG=$1
    DOCKER_FILE=$2
    echo ""
    echo "Building Container " $TAG $DOCKER_FILE
    echo ""
    docker build -t $TAG -f $DOCKER_FILE $3 $4 $5 .
    
}

# This will push the container to the registry
# Args
#   $1 - Container Tag
function Push_Container(){
    TAG=$1
    docker push $TAG
}

####################################################

####################################################
#####  Overview
####################################################

echo "-----  Overview  -----"
echo "ACTION_COMPILE: $ACTION_COMPILE"
echo "ACTION_BUILD:   $ACTION_BUILD"
echo "ACTION_PUSH:    $ACTION_PUSH"

echo "----------------------"
####################################################


if [ "$ACTION_COMPILE" == true ]; then
    # Build our code base
    echo "Building the auth plugin"
    go run build.go --release
fi

if [ "$ACTION_BUILD" == true ]; then
    Build_Container "$CONTAINER_TAG" "dockerfiles/cust-auth-plugin.dockerfile" --no-cache
fi

if [ "$ACTION_PUSH" == true ]; then
        Push_Container "$CONTAINER_TAG"
fi