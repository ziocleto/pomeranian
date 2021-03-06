#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo ${machine}

LIBNAME_NAME="$1"
LIBNAME_VERSION="$2"
GITUSER="$3"
OPTIONS=$4
INSTALL_PREFIX=$5

# if [ ${machine} == "MinGw" ]; then
# 	BUILDSYSTEMIMPL="MinGW Makefiles"
# 	BUILDSYSTEM="-G""$BUILDSYSTEMIMPL"
# 	OPTIONS="$OPTIONS"" -DCMAKE_INSTALL_PREFIX="c:/usr/local" -DCMAKE_SH="CMAKE_SH-NOTFOUND""
# 	export CXXFLAGS=-isystem\ c:/usr/local/include
# 	export LDFLAGS="-Lc:/usr/local/lib"
# 	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:c:/usr/local/lib
# fi

mkdir $LIBNAME_NAME
cd $LIBNAME_NAME
git clone --recursive --branch=$LIBNAME_VERSION https://github.com/$GITUSER/$LIBNAME_NAME.git
mkdir builder
cd builder
echo "Using OPTIONS: " 
echo $OPTIONS
cmake $OPTIONS -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX $LIBNAME_NAME -DBUILD_SHARED_LIBS=OFF ../$LIBNAME_NAME
make -j8
sudo make install
sudo make clean
