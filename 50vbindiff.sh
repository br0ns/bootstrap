#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install vbindiff VBinDiff

require perl

goto_tempdir

git clone https://github.com/madsen/vbindiff.git .
git submodule update --init
cpan Template
autoreconf -i
./configure
make
sudo make install
