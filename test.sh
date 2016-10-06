#!/bin/bash

set -e

IMAGE="lazyfrosch/rpm-build:7"

usage() {
    (
        echo
        echo "./test <command>"
        echo
    ) >&2
    exit 1
}

if [ "$*" = "" ]; then
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
    ./test.sh "$@"
else
    set -xe
    $@
fi
