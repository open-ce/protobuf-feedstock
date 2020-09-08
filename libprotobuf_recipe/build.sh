#!/bin/bash
# *****************************************************************
#
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corp. 2019, 2020. All Rights Reserved.
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
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
