#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install z3 Z3

goto_tempdir

sudo rm -rf /opt/z3
sudo mkdir /opt/z3

git clone git@github.com:Z3Prover/z3.git .
sudo python scripts/mk_make.py --prefix=/opt/z3
cd build
sudo make
sudo make install
