#!/bin/bash
source "$(dirname "$0")/bootstrap"

prompt_install rofi Rofi

require \
    autoconf automake libpango1.0-dev libxinerama-dev make

INFO Installing Rofi

goto_tempdir
# clone repo in tmp dir
run git clone git@github.com:DaveDavenport/rofi.git .

# recipe from INSTALL.md
run autoreconf -i
run mkdir build
run cd build
run ../configure --prefix=/opt/rofi
run make
run sudo make install

assert installed rofi
