#!/bin/bash
source "$(dirname "$0")/bootstrap"

# Look for an arbitrary binary
prompt_install i386-unknown-linux-gnu-ar binutils

goto_tempdir

require gcc make texinfo

run wget http://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.gz http://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.gz.sig
run gpg --verify binutils-2.25.tar.gz.sig || exit 1

run tar zxfv binutils-2.25.tar.gz

for TARGET in i386 x86_64 aarch64 alpha avr arm mips msp430 powerpc m68k sparc vax; do
    run rm -rf build
    run mkdir build
    run pushd build
    run ../binutils-2.25/configure --prefix=/opt/binutils-$TARGET \
                               --target=$TARGET-unknown-linux-gnu --disable-static --disable-multilib \
                               --disable-werror --disable-nls && \
        run make -j5 && sudo make install
    run popd
done
