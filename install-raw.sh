#!/usr/bin/env bash

set -e

tmpdir=$(mktemp -d)
cd $tmpdir
curl -LO https://github.com/9beach/mpv-app-bundle/archive/refs/heads/main.zip 
unzip main.zip
cd mpv-app-bundle-main
./install.sh
cd ../..
rm -rf $tmpdir
