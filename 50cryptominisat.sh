#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install cryptominisat4_simple CryptoMiniSat

# vim-common supplies `xxd'
require build-essential cmake vim-common libm4ri

goto_tempdir

git clone git@github.com:msoos/cryptominisat.git .
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/opt/cryptominisat ..
make -j4
sudo make install
sudo ldconfig
