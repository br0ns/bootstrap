#!/bin/bash
source "$(dirname "$0")/bootstrap"

if ! installed emacs ; then
    prompt_install emacs Emacs
    require emacs emacs-goodies-el
fi

if [ ! -d .emacs.d/elpa ] && \
       promptyn "Install Emacs packages now?" "y" ; then
    INFO Installing "Emacs packages"
    run .emacs.d/install-packages.sh
fi
