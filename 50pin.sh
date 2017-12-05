#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install /opt/pin Pin

require gcc lsb-release

goto_tempdir

wget http://software.intel.com/sites/landingpage/pintool/downloads/pin-3.2-81205-gcc-linux.tar.gz

tar xfv *.tar.gz
sudo rm -rf /opt/pin
sudo mv pin*/ /opt/pin
cd /opt/pin/source/tools
sudo make all TARGET=intel64
sudo make all TARGET=ia32
