#!/bin/bash
source "$(dirname "$0")/bootstrap"

prompt_install cryptominisat_simple CryptoMiniSat

require build-essential cmake

goto_tempdir

run git clone git@github.com:msoos/cryptominisat.git .
run mkdir build
run cd build
run cmake -DCMAKE_INSTALL_PREFIX=/opt/cryptominisat ..
run make -j4
run sudo make install
run sudo ldconfig
