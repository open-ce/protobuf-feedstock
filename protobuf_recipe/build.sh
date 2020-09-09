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

# Install python package now
cd python

mkdir -p google/protobuf/util
mkdir -p google/protobuf/compiler
touch google/protobuf/util/__init__.py
touch google/protobuf/compiler/__init__.py

python setup.py install --cpp_implementation --single-version-externally-managed --record record.txt
