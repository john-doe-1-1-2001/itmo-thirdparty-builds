#!/usr/bin/env bash

set -euo pipefail

REPOSITORY="https://github.com/madler/zlib.git"
VERSION="v1.3.2"

git clone --branch ${VERSION} --depth 1 ${REPOSITORY} sources

cp -v {PATCH,CMakePresets.json} ./sources/

pushd sources
    git apply PATCH

    for preset in Release Debug Sanitized
    do
        p=$(echo "${preset}" | tr '[:upper:]' '[:lower:]')
        name="zlib.linux.${THIRD_PARTY_SUFFIX_NAME}.${p}"
        zip_name="${name}.zip"

        mkdir -v build

        pushd build
            cmake .. --preset zlib-${preset} \
                     -D CMAKE_INSTALL_PREFIX=../install/zlib \
                     -D CMAKE_C_COMPILER=${THIRD_PARTY_C_COMPILER} \
                     -D CMAKE_CXX_COMPILER=${THIRD_PARTY_CXX_COMPILER}
            make && make install
        popd

        pushd install
            zip -9 -r ${zip_name} ./zlib/
        popd

        mv -v ./install/${zip_name} ..
        rm -rf build install
    done
popd
