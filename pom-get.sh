docker pull pomeranian/$1
POMCONTAINER=$(docker container ls -aql -f "ancestor=pomeranian/$1")
docker cp $POMCONTAINER:/build/. $2
docker image rm pomeranian/$1