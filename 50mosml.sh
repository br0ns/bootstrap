#!/bin/bash
source "$(dirname "$0")/bootstrap"

prompt_install mosml MoscowML

goto_tempdir

run git clone git@github.com:kfl/mosml.git .
cd src
run make
run sudo make install
