#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install pip

# require

goto_tempdir

wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
