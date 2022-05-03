#!/bin/bash

mkdir build
cd build
/src/gcc/configure --enable-languages=c,c++ --disable-multilib
make -j$(nproc)

mkdir gcc-$1
make -j$(nproc) install DESTDIR=/src/gcc-$1
