#!/bin/bash
source "$(dirname "$0")/bootstrap"

prompt_install voltron

goto_tempdir

require libreadline-dev

run git clone https://github.com/snare/voltron.git .
run sudo python setup.py install
