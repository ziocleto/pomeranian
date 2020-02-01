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
	echo "$POMERANIAN_TOKEN" | docker login -u pomeranian --password-stdin
	docker build -t pomeranian/$1 -f dockerfile-$1 .
	docker push pomeranian/$1
fi
