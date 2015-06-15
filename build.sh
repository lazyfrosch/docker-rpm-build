#!/bin/bash

set -e

IMAGE="$1"
SPEC="$2"

usage() {
    (
        echo
        echo "./build.sh <image> <spec>"
        echo
    ) >&2
    exit 1
}

if [ "$IMAGE" = "" ]; then
    echo "Please specify docker image!" >&2
    usage
fi
if [ ! -f "$SPEC" ]; then
    echo "Please specify spec file!" >&2
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
    ./build.sh "$@"
else
    set -xe
    sudo yum-builddep -y "$LOC/$SPEC"
    export CCACHE_DIR="$LOC/ccache"
    PATH="/usr/lib64/ccache:$PATH"
    dist=`rpmbuild -E %dist | sed 's/^\.//'`
    shift
    shift
    if ! rpmbuild \
        --define "_topdir $LOC" \
        --define "_builddir %{_topdir}/BUILD/$dist" \
        --define "_rpmdir %{_topdir}/RPMS/$dist" \
        --define "_srcrpmdir %{_topdir}/SRPMS/$dist" \
        -ba "$LOC/$SPEC" \
        "$@"
    then
        ret=$?
        echo "Spawning shell for debugging..."
        /bin/bash
        exit $ret
    fi
fi
