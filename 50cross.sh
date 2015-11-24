#!/bin/bash
source "$(dirname "$0")/bs.sh"

# XXX:
# XXX: This script does not work yet!
# XXX:

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
wget http://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz
wget http://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz.sig
gpg --verify binutils-$BINUTILS_VERSION.tar.gz.sig || exit 1
tar zxfv binutils-$BINUTILS_VERSION.tar.gz

for ARCH in i386 x86_64 aarch64 alpha avr arm mips msp430 powerpc m68k sparc vax; do
    PREFIX=$(PREFIX $ARCH)
    TARGET=$(TARGET $ARCH)
    PATH="$PREFIX/bin:$PATH"

    echo $PREFIX
    echo $TARGET

    rm -rf build-binutil
    mkdir build-binutil
    pushd build-binutil
    ../binutils-$BINUTILS_VERSION/configure --prefix=$PREFIX \
        --target=$TARGET --disable-nls --disable-multilib
    make -j$PARALLELISM
    sudo make install
    popd
done

# Then install the latest and greatest GCC in the host
wget https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz
tar zxfv gcc-$GCC_VERSION.tar.gz
pushd gcc-$GCC_VERSION/contrib
./download_prerequisites
popd

rm -rf build-gcc
mkdir build-gcc
pushd build-gcc
../gcc-$GCC_VERSION/configure --prefix=/opt/gcc --disable-nls
make -j$PARALLELISM
sudo make install
popd

PATH="/opt/gcc:$PATH"

# Download Linux kernel
wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-$LINUX_VERSION.tar.xz
tar Jxfv linux-$LINUX_VERSION.tar.xz

# Download GLIBC
wget https://ftp.gnu.org/gnu/glibc/glibc-$GLIBC_VERSION.tar.gz
wget https://ftp.gnu.org/gnu/glibc/glibc-$GLIBC_VERSION.tar.gz.sig
gpg --verify glibc-$GLIBC_VERSION.tar.gz.sig || exit 1
tar zxfv glibc-$GLIBC_VERSION.tar.gz

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
    pushd linux-$LINUX_VERSION
    sudo make ARCH=$(LINUXARCH $ARCH) INSTALL_HDR_PATH=$PREFIX/$TARGET \
        headers_install
    popd

    # Build a "naked" GCC
    rm -rf build-gcc
    mkdir build-gcc
    pushd build-gcc
    ../gcc-$GCC_VERSION/configure --prefix=$PREFIX --target=$TARGET \
        --enable-languages=c,c++ --disable-nls --disable-multilib
    make -j$PARALLELISM all-gcc
    sudo env "PATH=\"$PATH\"" make install-gcc
    popd

    # glibc headers and CRT
    sudo rm -rf build-glibc
    mkdir build-glibc
    pushd build-glibc
    ../glibc-$GLIBC_VERSION/configure --prefix=$PREFIX/$TARGET \
        --build=$MACHTYPE --host=$TARGET --target=$TARGET \
        --with-headers=$PREFIX/$TARGET/include --disable-multilib \
        libc_cv_forced_unwind=yes
    sudo env "PATH=$PREFIX/bin:$PATH" make install-bootstrap-headers=yes \
        install-headers
    make -j$PARALLELISM csu/subdir_lib
    sudo install csu/crt1.o csu/crti.o csu/crtn.o $PREFIX/$TARGET/lib
    env "PATH=$PREFIX/bin:$PATH" sudo $TARGET-gcc -nostdlib -nostartfiles \
        -shared -x c /dev/null -o $PREFIX/$TARGET/lib/libc.so
    sudo touch $PREFIX/$TARGET/include/gnu/stubs.h
    popd

    # # libgcc
    # pushd build-gcc
    # make -j$PARALLELISM all-target-libgcc
    # sudo make install-target-libgcc
    # popd

    # # glibc
    # pushd build-glibc
    # sudo env "PATH=$PREFIX/bin:$PATH" make -j$PARALLELISM
    # sudo env "PATH=$PREFIX/bin:$PATH" make -j$PARALLELISM all
    # sudo env "PATH=$PREFIX/bin:$PATH" make install
    # popd

    # # gcc
    # pushd build-gcc
    # sudo env "PATH=$PREFIX/bin:$PATH" make -j$PARALLELISM all
    # sudo env "PATH=$PREFIX/bin:$PATH" make install
    # popd
done
