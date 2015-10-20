#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install /usr/lib/libcapstone.a Capstone

goto_tempdir

git clone https://github.com/aquynh/capstone
cd capstone
git checkout -t origin/next
sudo ./make.sh install
cd bindings/python
sudo python setup.py install
