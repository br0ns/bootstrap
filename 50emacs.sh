#!/bin/bash
source "$(dirname "$0")/bs.sh"

# This `if` is needed to avoid exiting if Emacs is already installed
if ! installed emacs ; then
    prompt_install emacs Emacs
    require emacs emacs-goodies-el
fi

if [ ! -d .emacs.d/elpa ] && \
       promptyn "Install Emacs packages now?" "y" ; then
    INFO Installing "Emacs packages"
    .emacs.d/install-packages.sh
fi
