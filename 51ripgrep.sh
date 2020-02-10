#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install rg RipGrep

if ! installed cargo ; then
    if promptyn "Rust is not installed.  Install now?" y ; then
        bash "$(dirname "$0")/50rust.sh"
    else
        exit 1
    fi
fi

cargo update && cargo install ripgrep
