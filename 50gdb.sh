#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install gdb GDB

# List from `apt-rdepends --build-depends --follow=DEPENDS gdb`
require autoconf bison bzip2 cdbs debhelper dejagnu flex-old g++ gettext \
        gobjc libbabeltrace-ctf-dev libbabeltrace-dev libexpat1-dev \
        liblzma-dev libncurses5-dev libreadline-dev libtool lsb-release procps \
        python2.7-dev texinfo texlive-base zlib1g-dev

goto_tempdir

git clone git://sourceware.org/git/binutils-gdb.git .
./configure --with-python=python2
make

sudo make install
