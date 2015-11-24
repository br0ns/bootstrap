#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install check-pkgs

mkdir -p ~/bin

if [ ! -e ~/bin/net ] ; then
    wget https://raw.githubusercontent.com/br0ns/check-pkgs/master/check-pkgs -O ~/bin/check-pkgs
    chmod +x ~/bin/check-pkgs
fi
