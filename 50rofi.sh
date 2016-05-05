#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install rofi Rofi

require \
    autoconf \
    automake \
    libpango1.0-dev \
    libxinerama-dev make \
    libstartup-notification0-dev \
    libxcb1-dev \
    libxcb-xkb-dev \
    libxcb-ewmh-dev \
    libxcb-util0-dev \
    libxcb-icccm4-dev \
    libxcb-xinerama0-dev \
    libx11-xcb-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev

INFO Installing Rofi

goto_tempdir

git clone git@github.com:DaveDavenport/rofi.git .

# recipe from INSTALL.md
git submodule update --init
autoreconf -i
mkdir build
cd build
../configure --prefix=/opt/rofi
make
sudo make install

# Update PATH maybe?
[ -f ~/.profile ] && . ~/.profile

assert installed rofi
