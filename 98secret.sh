#!/bin/bash
source "$(dirname "$0")/bs.sh"

if [ -e .secret/secret.lst ] ; then
    default="n"
else
    default="y"
fi

prompt_step "Run \`secret.py restore' now?" $default

.secret/secret.py restore
