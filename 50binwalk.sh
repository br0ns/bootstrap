#!/bin/bash
source "$(dirname "$0")/bootstrap"

prompt_install binwalk Binwalk

require python-lzma

goto_tempdir

run git clone git@github.com:devttys0/binwalk.git .
run sudo python setup.py install --prefix /opt/binwalk
