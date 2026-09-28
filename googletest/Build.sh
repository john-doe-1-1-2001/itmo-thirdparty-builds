#!/usr/bin/env bash

set -euo pipefail

REPOSITORY="https://github.com/google/googletest.git"
VERSION="v1.18.0"

git clone --branch ${VERSION} --depth 1 ${REPOSITORY} sources

cp -v {PATCH,CMakePresets.json} ./sources/

pushd sources
    git apply PATCH

    for preset in Release Debug Sanitized
    do
        p=$(echo "${preset}" | tr '[:upper:]' '[:lower:]')
        name="googletest.linux.${THIRD_PARTY_SUFFIX_NAME}.${p}"
        zip_name="${name}.zip"

        mkdir -v build

        pushd build
            cmake .. --preset GoogleTest-${preset} \
                     -D CMAKE_INSTALL_PREFIX=../install/googletest \
                     -D CMAKE_C_COMPILER=${THIRD_PARTY_C_COMPILER} \
                     -D CMAKE_CXX_COMPILER=${THIRD_PARTY_CXX_COMPILER}
            make && make install
        popd

        pushd install
            zip -9 -r ${zip_name} ./googletest/
        popd

        mv -v ./install/${zip_name} ..
        rm -rf build install
    done
popd
