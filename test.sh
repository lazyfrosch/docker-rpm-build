#!/bin/bash

set -e

IMAGE="$1"
shift

usage() {
    (
        echo
        echo "./test <image> <command>"
        echo
    ) >&2
    exit 1
}

if [ "$IMAGE" = "" ]; then
    echo "Please specify docker image!" >&2
    usage
fi
if [ "$@" = "" ]; then
    echo "Please specify command!" >&2
    usage
fi

LOC="/tmp/build"
if [ `id -un` != "build" ]; then
    set -x
    docker run \
        -i -t \
        -v `pwd`:"$LOC" \
        -u build \
        -w "$LOC" \
        --rm \
        "$IMAGE" \
    ./test.sh inside "$@"
else
    set -xe
    $@
fi
