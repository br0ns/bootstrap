#!/bin/bash
source "$(dirname "$0")/bootstrap"

prompt_install afl-fuzz "American Fuzzy Lop"

require libtool-bin automake autoconf bison libglib2.0-dev

goto_tempdir

run wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
run tar xzf afl-latest.tgz
run cd afl-*
run make
cd qemu_mode
run ./build_qemu_support.sh
cd ..
run sudo make install
