#!/bin/bash
source "$(dirname "$0")/bootstrap"

require \
    coreutils git gnupg netcat-openbsd python ssh tar vcsh wget
