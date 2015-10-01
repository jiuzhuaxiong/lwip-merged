#!/bin/bash

cd contrib/ports/unix/proj/lib
#build library
make clean all
ERR=$?
if [ $ERR != 0 ]; then
       echo "library failed"
       exit 33
fi
cd ../minimal
#build minimal app
make clean all
ERR=$?
if [ $ERR != 0 ]; then
       echo "minimal failed"
       exit 33
fi
cd ../unixsim
#build unixsim app
make clean
make ARCH=linux all
ERR=$?
if [ $ERR != 0 ]; then
       echo "unixsim failed"
       exit 33
fi
cd ../../check
#build and run unit tests
make clean all
ERR=$?
if [ $ERR != 0 ]; then
       echo "unittests build failed"
       exit 33
fi
make check
