#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install kstool Keystone

require gcc libc6-dev cmake

goto_tempdir

git clone https://github.com/keystone-engine/keystone.git
cd keystone
mkdir build
cd build
../make-share.sh
sudo make install
sudo ldconfig

cd ../bindings/python
sudo make install
