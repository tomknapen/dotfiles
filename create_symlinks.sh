#!/usr/bin/env bash

function createSymlinks() {
    cd "$(dirname "${BASH_SOURCE}")";

    # TODO: remove when putting symlinks in ~
    rm -rf ./lntest
    mkdir ./lntest

    # create folder structure
    find ./dots -type d -exec mkdir ./lntest/{} \;

    # create symlinks
    find ./dots -type f -exec ln -s `pwd`/{} ./lntest/{} \;

    # move to symlinks up the tree and drop dots folder from path
    shopt -s dotglob

    rm -rf ./symlinks
    mkdir ./symlinks
    mv ./lntest/dots/* ./symlinks
    rm -rf ./lntest

    # list symlinks
    find ./symlinks -type l -ls  

    shopt -u dotglob
}

createSymlinks;

unset createSymlinks;