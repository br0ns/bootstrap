#!/bin/bash
source "$(dirname "$0")/bs.sh"

# Look for an arbitrary binary
prompt_install i386-unknown-linux-gnu-ar binutils

goto_tempdir

require gcc make texinfo

PARALLELISM=8
BINUTILS_VERSION=2.25

wget http://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz
wget http://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz.sig
gpg --verify binutils-$BINUTILS_VERSION.tar.gz.sig
tar zxfv binutils-$BINUTILS_VERSION.tar.gz

function PREFIX () {
    echo /opt/cross-$1
}

function TARGET () {
    echo $1-unknown-linux-gnu
}

for ARCH in i386 x86_64 aarch64 alpha avr arm mips msp430 powerpc m68k sparc vax; do
    PREFIX=$(PREFIX $ARCH)
    TARGET=$(TARGET $ARCH)

    rm -rf build
    mkdir build
    pushd build
    sudo ../binutils-$BINUTILS_VERSION/configure \
        --prefix=$PREFIX \
        --target=$TARGET \
        --disable-nls \
        --disable-multilib \
        --disable-static \
        --disable-werror
    make -j$PARALLELISM
    sudo make install
    popd
done
