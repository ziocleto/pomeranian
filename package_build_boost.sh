#!/bin/bash

P1="$1"
P2="$2"
P3="$3"
LIBNAME_NAME=boost

docker build -t pomeranian/$LIBNAME_NAME:$P1.$P2.$P3 -f dockerfile-boost --build-arg P1=$P1 --build-arg P2=$P2 --build-arg P3=$P3 .
echo "$POMERANIAN_TOKEN" | docker login -u pomeranian --password-stdin
docker push pomeranian/$LIBNAME_NAME
