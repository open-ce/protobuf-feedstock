#!/bin/bash
# *****************************************************************
# (C) Copyright IBM Corp. 2019, 2021. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# *****************************************************************

set -ex

# protobuf uses PROTOBUF_OPT_FLAG to set the optimization level
# unit test can fail if optmization above 0 are used.
CPPFLAGS="${CPPFLAGS//-O[0-9]/}"
CXXFLAGS="${CXXFLAGS//-O[0-9]/}"
export PROTOBUF_OPT_FLAG="-O2"
# to improve performance, disable checks intended for debugging
CXXFLAGS="$CXXFLAGS -DNDEBUG"

# required to pick up conda installed zlib
export CPPFLAGS="${CPPFLAGS} -I${PREFIX}/include"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"

# hack because set and grep are not is /usr/bin in ubuntu
export SED=
export GREP=

# Build configure/Makefile as they are not present.
aclocal
libtoolize
autoconf
autoreconf -i
automake --add-missing

#./autogen.sh
./configure --prefix="${PREFIX}" \
            --build=${HOST}      \
            --host=${HOST}       \
            --with-pic           \
            --with-zlib          \
            --enable-shared      \
            --enable-static      \
            CC_FOR_BUILD=${CC}   \
            CXX_FOR_BUILD=${CXX}
make -j ${CPU_COUNT}
make install
