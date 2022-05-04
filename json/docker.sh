#!/bin/bash

THIS=$(readlink -e $0)

mkdir build
cd build
cmake /src/json

mkdir json-$1
make -j$(nproc) install DESTDIR=/src/json-$1
cp $THIS /src/json-$1
