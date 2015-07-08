#!/bin/bash
source "$(dirname "$0")/bootstrap"

prompt_install z3 Z3

goto_tempdir

run sudo rm -rf /opt/z3
run sudo mkdir /opt/z3

run git clone git@github.com:Z3Prover/z3.git .
run python scripts/mk_make.py --prefix=/opt/z3
run cd build
run sudo make
run sudo make install
