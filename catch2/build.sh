#!/bin/bash

# This script is meant to make it easy to build GCC using a Docker container.

# Run this from the same directory as fmt source directory

THIS=$(readlink -e $0)
USER_ID=`id -u`
GROUP_ID=`id -g`
VERSION=2.13.9
PKG_NAME=catch2

mkdir -p $PKG_NAME-$VERSION

docker run -v $(pwd):/src -w /src -u root -t debian:yuzu /bin/bash /src/docker.sh $VERSION

cp -v $THIS $PKG_NAME-$VERSION/
tar cv $PKG_NAME-$VERSION | xz -T0 -c > $PKG_NAME-$VERSION.tar.xz
