#!/bin/bash
source "$(dirname "$0")/bs.sh"

if [ ! -e /etc/sysctl.d/10-ptrace.conf ] ; then
    sudo tee /etc/sysctl.d/10-ptrace.conf <<EOF
kernel.yama.ptrace_scope = 0
EOF
fi
