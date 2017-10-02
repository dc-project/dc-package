#!/bin/bash
set -o errexit

PROGRAM="dc"

releasedir=./.release
VERSION=0.0.1
buildRelease=10.02

function prepare() {
    echo "---> Prepare Build"
    rm -rf $releasedir
    mkdir -p $releasedir
}

function build() {
    echo "---> Build code... Pass"
}

function build::deb() {
    echo "---> Make Build DEB"
    source "hack/build-deb.sh"
}

function build::rpm() {
    echo "---> Make Build RPM"
    source "hack/build-rpm.sh"
}

function add_repo() {
    echo "add deb/rpm package to repo"
    echo "---> show package list"
}

action=$1

case $action in
    build)
            prepare
            build
    ;;
    deb)
            build::deb
    ;;
    rpm)
            build::rpm
    ;;
    repo)
            add_repo
    ;;
    *)
            prepare
            build
            build::deb
            build::rpm
            add_repo
    ;;
esac
