#!/bin/bash
source "$(dirname "$0")/bootstrap"

if [ -e .secret/secret.lst ] ; then
    default="n"
else
    default="y"
fi

prompt_step "Run \`secret.py restore' now?" $default

run .secret/secret.py restore
