#!/bin/bash

# This script is meant to make it easy to rebuild packages using the
# linux-fresh yuzu-emu container.

# Run this from within the source directory

THIS=$(readlink -e $0)
USER_ID=${1}
GROUP_ID=${2}
VERSION=deb
BASE_NAME=$(readlink -e $(pwd) | sed 's/.*\///g')
ARCHIVE_NAME=${BASE_NAME}_${VERSION}
NUM_CORES=$(nproc)

export PATH=/opt/cmake-3.23.1/bin:$PATH

mkdir build || true
cd build
mkdir out || true
../configure -opensource -confirm-license -prefix $(pwd)/${ARCHIVE_NAME} -gtk -icu -skip qtwebengine -skip qtlocation -skip qtdocgallery
make -j${NUM_CORES} NINJAJOBS=-j${NUM_CORES}
make -j${NUM_CORES} install DESTDIR=out

cp -v $THIS ${ARCHIVE_NAME}

# Don't forget to include ICU libraries, then run `patchelf --set-rpath '$ORIGIN/../lib' [library]` on all of them
find /usr/lib/ -regex '.*icu.*.so.63$' -exec cp -Lv {} ${ARCHIVE_NAME}/lib ';'
find /usr/lib/ -regex '.*double-conversion.*.so.1$' -exec cp -Lv {} ${ARCHIVE_NAME}/lib ';'
find ${ARCHIVE_NAME}/bin -exec patchelf --set-rpath '$ORIGIN/../lib' {} ';'
find ${ARCHIVE_NAME}/lib -exec patchelf --set-rpath '$ORIGIN/../lib' {} ';'

tar c ${ARCHIVE_NAME} | xz -T0 -c > ${ARCHIVE_NAME}.tar.xz

