#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install afl-fuzz "American Fuzzy Lop"

require libtool-bin automake autoconf bison libglib2.0-dev

goto_tempdir

wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
tar xzf afl-latest.tgz
cd afl-*
make
cd qemu_mode
./build_qemu_support.sh
cd ..
sudo make install
