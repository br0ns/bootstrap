#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install binwalk Binwalk

require python-lzma

goto_tempdir

git clone git@github.com:devttys0/binwalk.git .
sudo python setup.py install --prefix /opt/binwalk
