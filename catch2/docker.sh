#!/bin/bash

THIS=$(readlink -e $0)

mkdir build
cd build
cmake /src/Catch2 -DBUILD_TESTING=OFF

mkdir catch2-$1
make -j$(nproc) install DESTDIR=/src/catch2-$1
cp $THIS /src/catch2-$1
