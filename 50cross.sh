#!/bin/bash
source "$(dirname "$0")/bs.sh"

# Look for an arbitrary binary
# prompt_install i386-unknown-linux-gnu-ar binutils

goto_tempdir

require gcc make texinfo libmpfr-dev libmpc-dev gawk

PARALLELISM=8

BINUTILS_VERSION=2.25
GCC_VERSION=5.2.0
LINUX_VERSION=4.1.3
GLIBC_VERSION=2.21

function PREFIX () {
    echo /opt/cross-$1
}

function TARGET () {
    case $1 in
        arm)
            echo $1-linux-gnueabi
            ;;
        *)
            echo $1-linux-gnu
            ;;
    esac
}

function LINUXARCH () {
    case $1 in
        aarch64)
            echo arm64
            ;;
        avr)
            echo avr32
            ;;
        *)
            echo $1
            ;;
    esac
}

# First install binutils
run wget http://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz
run wget http://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz.sig
run gpg --verify binutils-$BINUTILS_VERSION.tar.gz.sig || exit 1
run tar zxfv binutils-$BINUTILS_VERSION.tar.gz

for ARCH in i386 x86_64 aarch64 alpha avr arm mips msp430 powerpc m68k sparc vax; do
    PREFIX=$(PREFIX $ARCH)
    TARGET=$(TARGET $ARCH)
    PATH="$PREFIX/bin:$PATH"

    echo $PREFIX
    echo $TARGET

    run rm -rf build-binutil
    run mkdir build-binutil
    run pushd build-binutil
    run ../binutils-$BINUTILS_VERSION/configure --prefix=$PREFIX \
        --target=$TARGET --disable-nls --disable-multilib
    run make -j$PARALLELISM
    run sudo make install
    run popd
done

# Then install the latest and greatest GCC in the host
run wget https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz
run tar zxfv gcc-$GCC_VERSION.tar.gz
run pushd gcc-$GCC_VERSION/contrib
run ./download_prerequisites
run popd

run rm -rf build-gcc
run mkdir build-gcc
run pushd build-gcc
run ../gcc-$GCC_VERSION/configure --prefix=/opt/gcc --disable-nls
run make -j$PARALLELISM
run sudo make install
popd

PATH="/opt/gcc:$PATH"

# Download Linux kernel
run wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-$LINUX_VERSION.tar.xz
run tar Jxfv linux-$LINUX_VERSION.tar.xz

# Download GLIBC
run wget https://ftp.gnu.org/gnu/glibc/glibc-$GLIBC_VERSION.tar.gz
run wget https://ftp.gnu.org/gnu/glibc/glibc-$GLIBC_VERSION.tar.gz.sig
run gpg --verify glibc-$GLIBC_VERSION.tar.gz.sig || exit 1
run tar zxfv glibc-$GLIBC_VERSION.tar.gz

# There are no kernel headers for MSP430, but it is in APT
require gcc-msp430

for ARCH in i386 x86_64 aarch64 alpha avr arm mips powerpc m68k sparc; do
    # Don't install a cross compiler for the host system
    if [[ "$MACHTYPE" =~ "$ARCH"* ]] ; then
        continue
    fi

    PREFIX=$(PREFIX $ARCH)
    TARGET=$(TARGET $ARCH)

    # Build Linux kernel headers
    run pushd linux-$LINUX_VERSION
    run sudo make ARCH=$(LINUXARCH $ARCH) INSTALL_HDR_PATH=$PREFIX/$TARGET \
        headers_install
    run popd

    # Build a "naked" GCC
    run rm -rf build-gcc
    run mkdir build-gcc
    run pushd build-gcc
    run ../gcc-$GCC_VERSION/configure --prefix=$PREFIX --target=$TARGET \
        --enable-languages=c,c++ --disable-nls --disable-multilib
    run make -j$PARALLELISM all-gcc
    run sudo env "PATH=\"$PATH\"" make install-gcc
    popd

    # glibc headers and CRT
    run sudo rm -rf build-glibc
    run mkdir build-glibc
    run pushd build-glibc
    run ../glibc-$GLIBC_VERSION/configure --prefix=$PREFIX/$TARGET \
        --build=$MACHTYPE --host=$TARGET --target=$TARGET \
        --with-headers=$PREFIX/$TARGET/include --disable-multilib \
        libc_cv_forced_unwind=yes
    run sudo env "PATH=$PREFIX/bin:$PATH" make install-bootstrap-headers=yes \
        install-headers
    run make -j$PARALLELISM csu/subdir_lib
    run sudo install csu/crt1.o csu/crti.o csu/crtn.o $PREFIX/$TARGET/lib
    run env "PATH=$PREFIX/bin:$PATH" sudo $TARGET-gcc -nostdlib -nostartfiles \
        -shared -x c /dev/null -o $PREFIX/$TARGET/lib/libc.so
    run sudo touch $PREFIX/$TARGET/include/gnu/stubs.h
    run popd

    # # libgcc
    # run pushd build-gcc
    # run make -j$PARALLELISM all-target-libgcc
    # run sudo make install-target-libgcc
    # run popd

    # # glibc
    # run pushd build-glibc
    # run sudo env "PATH=$PREFIX/bin:$PATH" make -j$PARALLELISM
    # run sudo env "PATH=$PREFIX/bin:$PATH" make -j$PARALLELISM all
    # run sudo env "PATH=$PREFIX/bin:$PATH" make install
    # run popd

    # # gcc
    # run pushd build-gcc
    # run sudo env "PATH=$PREFIX/bin:$PATH" make -j$PARALLELISM all
    # run sudo env "PATH=$PREFIX/bin:$PATH" make install
    # run popd
done
