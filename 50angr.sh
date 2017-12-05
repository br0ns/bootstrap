#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install angr Angr

require virtualenvwrapper python2.7-dev build-essential libxml2-dev \
        libxslt1-dev git libffi-dev cmake libreadline-dev libtool debootstrap \
        debian-archive-keyring libglib2.0-dev libpixman-1-dev

goto_tempdir

git clone https://github.com/angr/angr .
mkvirtualenv angr
pip install .
