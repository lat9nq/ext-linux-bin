#!/bin/bash

# This script is meant to make it easy to build GCC using a Docker container.

# Run this from the same directory as glslang source directory

THIS=$(readlink -e $0)
USER_ID=`id -u`
GROUP_ID=`id -g`
VERSION=11.9.0
PKG_NAME=glslang

mkdir -p $PKG_NAME-$VERSION

docker run -v $(pwd):/src -w /src -u root -t debian:yuzu /bin/bash -e /src/docker.sh $VERSION

cp -v $THIS $PKG_NAME-$VERSION/
tar cv $PKG_NAME-$VERSION | xz -T0 -c > $PKG_NAME-$VERSION.tar.xz
