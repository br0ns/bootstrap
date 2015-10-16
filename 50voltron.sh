#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install voltron

goto_tempdir

require libreadline-dev

git clone https://github.com/snare/voltron.git .
sudo python setup.py install
