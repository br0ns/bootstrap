#!/bin/bash
source "$(dirname "$0")/bs.sh"

if [ ! -e /etc/apt/apt.conf.d/01norecommend ] ; then
    sudo tee /etc/apt/apt.conf.d/01norecommend <<EOF
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOF
fi
