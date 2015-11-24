#!/bin/bash
source "$(dirname "$0")/bs.sh"

# XXX:
# XXX: This script does not work yet!
# XXX:

# prompt_install klee Klee

require build-essential curl git bison flex bc libcap-dev cmake \
        libboost-all-dev libncurses5-dev python-minimal python-pip unzip

goto_tempdir

# From http://klee.github.io/build-llvm34/
git clone https://github.com/stp/minisat.git
cd minisat
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/ ../
sudo make install
cd ../../
git clone https://github.com/stp/stp.git
mkdir stp/build
cd stp/build
cmake -DBUILD_SHARED_LIBS:BOOL=OFF -DENABLE_PYTHON_INTERFACE:BOOL=OFF ..
make
sudo make install
cd ..

git clone https://github.com/klee/klee.git
cd klee
#./configure --with-stp=/full/path/to/stp/build
