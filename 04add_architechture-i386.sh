#!/bin/bash
source "$(dirname "$0")/bootstrap"

arch=i386
if [[ ! "$(dpkg --print-foreign-architectures)" =~ "$arch" ]] ; then
    echo "Adding APT foreign architecture: $arch"
    run sudo dpkg --add-architecture $arch
    echo "DONE"
    echo
fi
