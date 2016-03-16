#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install ag "Silver Searcher"

require automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev

goto_tempdir

git clone git@github.com:br0ns/the_silver_searcher.git .
./build.sh
sudo make install
