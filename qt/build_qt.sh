#!/bin/bash

# This script is meant to make it easy to rebuild packages using the
# linux-fresh yuzu-emu container.

# Run this from within the source directory

THIS=$(readlink -e $0)
USER_ID=${1}
GROUP_ID=${2}
VERSION=6_3_0
BASE_NAME=$(readlink -e $(pwd) | sed 's/.*\///g')
ARCHIVE_NAME=${BASE_NAME}_${VERSION}
NUM_CORES=$(nproc)

export PATH=/opt/cmake-3.23.1/bin:$PATH

mkdir build || true
cd build
mkdir out || true
../configure -opensource -confirm-license -prefix $(pwd)/${ARCHIVE_NAME} -gtk -icu -skip qtwebengine,qtpositioning,qtlocation \
    -- -DQT_BUILD_EXAMPLES_BY_DEFAULT=OFF -DQT_BUILD_TESTS_BY_DEFAULT=OFF -DQT_BUILD_TOOLS_BY_DEFAULT=OFF -Wno-dev
cmake --build . --parallel
cp /qt5/build/out/bin/qml /qt5/build/qtbase/bin/qmlprofiler
cp /qt5/build/out/bin/qml /qt5/build/qtbase/bin/qmlplugindump
cp /qt5/build/out/bin/qml /qt5/build/qtbase/libexec/qhelpgenerator
cmake --install .

cp -v $THIS ${ARCHIVE_NAME}

# Don't forget to include ICU libraries, then run `patchelf --set-rpath '$ORIGIN/../lib' [library]` on all of them
find /usr/lib/ -regex '.*icu.*.so.63$' -exec cp -Lv {} ${ARCHIVE_NAME}/lib ';'
find /usr/lib/ -regex '.*double-conversion.*.so.1$' -exec cp -Lv {} ${ARCHIVE_NAME}/lib ';'
find ${ARCHIVE_NAME}/lib/ -regex '.*icu.*.so.63$' -exec patchelf --set-rpath '$ORIGIN/../lib' {} ';'
find ${ARCHIVE_NAME}/lib/ -regex '.*double-conversion.*.so.1$' -exec patchelf --set-rpath '$ORIGIN/../lib' {} ';'

tar c ${ARCHIVE_NAME} | xz -T0 -c > ${ARCHIVE_NAME}.tar.xz

