#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

./create_symlinks.sh

shopt -s dotglob

rsync -a ./symlinks/* ~/
rm -rf ./symlinks

shopt -u dotglob