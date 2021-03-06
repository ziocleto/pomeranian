#!/bin/bash

build_and_run() {
	docker build -t pomeranian/$1 -t pomeranian/$1:$2 -f dockerfile-$1 .
	echo "$POMERANIAN_TOKEN" | docker login -u pomeranian --password-stdin
	docker push pomeranian/$1
	sudo rm dockerfile-$1
}

if [ -z "$1" ] 
then
    echo " "
    echo "pom: make a library today."
    echo " "
    echo "  Usage: pom.sh LIBRARY_NAME [VERSION TAGS...]"
    echo " "
    echo "That's it really, science is awesome!"
    echo " "
    exit 
fi

# OpenSSL
if [ "$1" == "openssl" ]
then
	if [ "$#" -ne 2 ]; then
    	echo " "
    	echo "Error: openssl builds requires to specify version number: "
    	echo "Use the following syntax: "
    	echo "  pom.sh openssl version"
    	echo " "
    	exit 1
	fi
	P1="$2"

	echo "FROM pomeranian/builder:9.2.0 as builder
WORKDIR /builder
RUN git clone --recursive --branch=$P1 https://github.com/openssl/openssl.git
RUN cd openssl && ./config no-shared --prefix=/build --openssldir=/build/openssl && make -j8 && make install

FROM alpine
COPY --from=builder /build/. /build/
" | sudo tee ./dockerfile-$1

	build_and_run $1 $2
	exit
fi

# Boost
if [ "$1" == "boost" ]
then
	if [ "$#" -ne 4 ]; then
    	echo " "
    	echo "Error: Boost builds requires to specify version number: "
    	echo "Use the following syntax: "
    	echo "  pom.sh boost MAJOR MINOR PATCH"
    	echo " "
    	exit 1
	fi
	P1="$2"
	P2="$3"
	P3="$4"
	TAG=$P1.$P2.$P3

	echo "FROM alpine as builder
WORKDIR /builder/boost
RUN wget https://dl.bintray.com/boostorg/release/$P1.$P2.$P3/source/boost_"$P1"_"$P2"_"$P3".tar.bz2
RUN tar --bzip2 -xf boost_"$P1"_"$P2"_"$P3".tar.bz2

FROM alpine
COPY --from=builder /builder/boost/boost_"$P1"_"$P2"_"$P3"/boost/. /build/include/boost/

" | sudo tee ./dockerfile-$1

	build_and_run $1 $TAG
	exit
fi

DEPS=""
if [ "$1" == "mongo-cxx-driver" ]
then
	DEPS="COPY --from=pomeranian/mongo-c-driver 		/build 			/usr/local
		  COPY --from=pomeranian/boost 		  		    /build 		 	/usr/local"
fi

if [ "$1" == "tesseract" ]
then
	DEPS="COPY --from=pomeranian/leptonica      		/build 			/usr/local"
fi

echo -e "FROM pomeranian/builder:9.2.0 as builder
$DEPS
RUN ./gitbuild.sh $1 $2 $3 \"$4\" /build
FROM alpine
COPY --from=builder /build /build" | sudo tee ./dockerfile-$1
build_and_run $1 $2$3

