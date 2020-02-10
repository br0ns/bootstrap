#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install /usr/lib/libunicorn.a Unicorn

require gcc libc6-dev libglib2.0-dev

goto_tempdir

git clone https://github.com/unicorn-engine/unicorn.git
cd unicorn
./make.sh
sudo ./make.sh install

cd bindings/python
sudo python setup.py install
