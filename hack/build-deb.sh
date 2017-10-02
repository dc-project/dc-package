#!/bin/bash
set -e

(
    debbuild_root=${releasedir}/deb
    for release_dir in $(find project/deb/* -maxdepth 0 -type d)
    do
        project=${release_dir##*/}
        debbuildRelease=${buildRelease}~stretch
        RELEASE_PATH=$debbuild_root/$project/${PROGRAM}-${project}-${debbuildRelease}
        echo $project,$debbuildRelease,$RELEASE_PATH
        rm -rf $debbuild_root/$project
        mkdir -pv $RELEASE_PATH
        cp -a $release_dir/debian $RELEASE_PATH/debian
        mkdir -p $RELEASE_PATH/usr/bin
        [ -d "$release_dir/files" ] && rsync -a $release_dir/files/ $RELEASE_PATH
        
        BUILD_IMAGE=projectdc/build:deb
        docker run --rm -v $PWD/$debbuild_root/$project:/debbuild -w /debbuild/${PROGRAM}-${project}-${debbuildRelease} -e VERSION=$VERSION -e debRelease=$debbuildRelease $BUILD_IMAGE build
    done
) 2>&1