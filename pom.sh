#!/bin/bash

if [ -z "$1" ] || [ "$#" -ne 1 ] 
then
    echo " "
    echo "pom, a pomeranian library shell script maker"
    echo " "
    echo "  Usage: pom.sh LIBRARY_NAME"
    echo " "
    echo "That's it really, science is awesome!"
    echo " "
else
	build_definition=$(<$1.def)
	echo "FROM pomeranian/builder:9.2.0 as builder
RUN ./gitbuild.sh $build_definition
FROM alpine
COPY --from=builder /build /build" | sudo tee ./dockerfile-$1

	echo "$POMERANIAN_TOKEN" | docker login -u pomeranian --password-stdin
	docker build -t pomeranian/$1 -f dockerfile-$1 .
	docker push pomeranian/$1
fi
