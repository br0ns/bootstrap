#!/bin/bash
source "$(dirname "$0")/bootstrap"

if [ ! -e /etc/sysctl.d/10-ptrace.conf ] ; then
    run sudo tee /etc/sysctl.d/10-ptrace.conf <<EOF
kernel.yama.ptrace_scope = 0
EOF
fi
