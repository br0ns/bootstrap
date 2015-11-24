#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install cado-nfs.py CadoNFS

require cmake libgmp-dev g++ python3

INFO Installing CadoNFS

goto_tempdir

sudo rm -rf /opt/cado-nfs
sudo mkdir /opt/cado-nfs

git clone https://gforge.inria.fr/git/cado-nfs/cado-nfs.git .

make PREFIX=/opt/cado-nfs cmake
make
sudo make install
