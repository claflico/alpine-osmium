#!/bin/bash

VERSION=$(cat Dockerfile | grep "OSMIUM_TOOL_VERSION=" | cut -d"=" -f2 | cut -d" " -f1)
IMAGE_NAME="claflico/alpine-osmium"

docker build -t $IMAGE_NAME:$VERSION .
docker tag $IMAGE_NAME:$VERSION $IMAGE_NAME:latest
