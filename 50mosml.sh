#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install mosml MoscowML

require libgmp-dev

goto_tempdir

git clone git@github.com:kfl/mosml.git .
cd src
make
sudo make install
