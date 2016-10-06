#!/bin/bash

set -e

IMAGE="lazyfrosch/rpm-build:7"
SPEC="$1"
VENDOR="built with docker-rpm-build by lazyfrosch"
CUSTOM_DIST=".lazyfrosch"

usage() {
    (
        echo
        echo "./build.sh <spec> <options>"
        echo
    ) >&2
    exit 1
}

if [ ! -f "$SPEC" ]; then
    if [ -n "$SPEC" ]; then
        SPEC="SPECS/${SPEC}.spec"
    fi
    if [ ! -f "$SPEC" ]; then
        echo "Please specify spec file!" >&2
        usage
    fi
fi

rpmbuild() {
    dist=`rpm -E %dist | sed 's/\(\.centos\)\?$/'"$CUSTOM_DIST"'/'`
    /usr/bin/rpmbuild \
        --define "vendor $VENDOR" \
        --define "dist $dist" \
        --define "_topdir $LOC" \
        --define "_rpmdir %{_topdir}/RPMS" \
        --define "_srcrpmdir %{_topdir}/SRPMS" \
    "$@"
}

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
    export CCACHE_DIR="$LOC/ccache"
    PATH="/usr/lib64/ccache:$PATH"
    shift

    # getting sources
    (cd SOURCES/ && spectool -g "../$SPEC")

    t=`mktemp`
    if ! rpmbuild --nodeps -bs "$LOC/$SPEC" > $t; then
        ret=$?
        echo "Building SRC RPM failed!" >&2
        exit $ret
    fi
    srpm=`cat $t`
    rm -f $t
    srpm=`echo "$srpm" | sed 's/Wrote: //'`

    sudo yum clean expire-cache
    sudo yum-builddep -y "$srpm"
    if ! rpmbuild -ba "$LOC/$SPEC" \
        "$@"
    then
        ret=$?
        echo "Spawning shell for debugging..." >&2
        /bin/bash
        exit $ret
    fi

    if ! rpmlint "$LOC/$SPEC"; then
        ret=$?
        echo "RPMlint failed!" >&2
        exit $ret
    fi
fi
