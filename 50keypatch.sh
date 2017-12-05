#!/bin/bash
source "$(dirname "$0")/bs.sh"

IDAPATH=$(ls -d /opt/ida* 2> /dev/null | head -n 1)

if [ -z $IDAPATH ] ; then
    WARN "IDA Pro is not installed"
    exit
fi

prompt_install $IDAPATH/plugins/keypatch.py Keypatch

cd $IDAPATH/plugins/
sudo wget https://raw.githubusercontent.com/keystone-engine/keypatch/master/keypatch.py

require gcc libc6-dev cmake

goto_tempdir

git clone https://github.com/keystone-engine/keystone.git
cd keystone
mkdir build
cd build
../make-share.sh lib32 lib_only
cd ..

sudo cp -r bindings/python/keystone $IDAPATH/python/
sudo cp -r /usr/lib/python2.7/distutils $IDAPATH/python/
sudo cp build/llvm/lib/libkeystone.so.* $IDAPATH/python/keystone/
