#!/bin/bash

cd contrib/ports/unix/proj/lib
#build library
make clean all
cd ../minimal
#build minimal app
make clean all
cd ../unixsim
#build unixsim app
make clean
make ARCH=linux all
make ARCH=linux simrouter
make ARCH=linux simnode
cd ../../check
#build and run unit tests
make clean all
make check
