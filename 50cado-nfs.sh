#!/bin/bash
source "$(dirname "$0")/bootstrap"

prompt_install factor.sh CadoNFS

require cmake libgmp3-dev

INFO Installing CadoNFS

goto_tempdir

run sudo rm -rf /opt/cado-nfs
run sudo mkdir /opt/cado-nfs

run git clone https://gforge.inria.fr/git/cado-nfs/cado-nfs.git .

run make PREFIX=/opt/cado-nfs cmake
run make
run sudo make install
