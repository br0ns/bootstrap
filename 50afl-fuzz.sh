#!/bin/bash
source "$(dirname "$0")/bootstrap"

prompt_install afl-fuzz "American Fuzzy Lop"

goto_tempdir

run wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
run tar xzf afl-latest.tgz
run cd afl-*
run make
run sudo make install
