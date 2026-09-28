#!/usr/bin/env bash

set -euo pipefail

check_var()
{
    local varname="${1}"
    local vardesc="${2}"
    if [ ! -v "${varname}" ]
    then
        echo "Variable ${varname} is not set!"
        echo "${varname}: ${vardesc}."
        exit 1
    fi
}

check_var THIRD_PARTY_C_COMPILER "sets C compiler for compiling packages"
check_var THIRD_PARTY_CXX_COMPILER "sets C++ compiler for compiling packages"
check_var THIRD_PARTY_SUFFIX_NAME "suffix name for packages [THIS IS TEMPORARY]"

for package in googletest zlib
do
    pushd ${package}
        ./Build.sh && mv -v *.zip ..
    popd
done
