#!/bin/bash -e

THIS=$(readlink -e $0)

mkdir build
cd build
cmake /src/glslang
make -j$(nproc)

mkdir glslang-$1
make -j$(nproc) install DESTDIR=/src/glslang-$1
cp $THIS /src/glslang-$1
