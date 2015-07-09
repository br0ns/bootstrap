#!/bin/bash
source "$(dirname "$0")/bootstrap"

prompt_install check-pkgs check-pkgs

run mkdir -p ~/bin
run wget https://raw.githubusercontent.com/br0ns/check-pkgs/master/check-pkgs -O ~/bin/check-pkgs
run chmod +x ~/bin/check-pkgs
run sudo tee /etc/apt/apt.conf.d/99check-pkgs <<EOF
DPkg::Post-Invoke {"$HOME/bin/check-pkgs";};
EOF
