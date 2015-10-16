#!/bin/bash
source "$(dirname "$0")/bs.sh"

arch=i386
if [[ ! "$(dpkg --print-foreign-architectures)" =~ "$arch" ]] ; then
    INFO "Adding APT foreign architecture: $arch"
    sudo dpkg --add-architecture $arch
fi
