echo "$POMERANIAN_TOKEN" | docker login -u pomeranian --password-stdin
docker build -t pomeranian/builder:9.2.0 -f dockerfile-builder-gcc920 .
docker push pomeranian/builder
