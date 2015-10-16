#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install rofi Rofi

require \
    autoconf automake libpango1.0-dev libxinerama-dev make

INFO Installing Rofi

goto_tempdir

git clone git@github.com:DaveDavenport/rofi.git .

# recipe from INSTALL.md
autoreconf -i
mkdir build
cd build
../configure --prefix=/opt/rofi
make
sudo make install

assert installed rofi
