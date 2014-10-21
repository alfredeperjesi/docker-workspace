#!/bin/bash
die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 1 ] || die "1 user name argument is required, $# provided"

sed 's/DOCKER_FOR/$1/g' Dockerfile_template > Dockerfile
