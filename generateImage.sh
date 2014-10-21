#!/bin/bash
die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "2 arguments required for tag name, $# provided."

sed 's/DOCKER_FOR/'$USER'/g' Dockerfile_template > Dockerfile

#docker build -t $1 --no-cache=true .
docker build -t $1 .

rm Dockerfile

echo 'Image is generated with '$1' for '$USER'!'
echo 'Usage: docker run -ith '$2' '$1
