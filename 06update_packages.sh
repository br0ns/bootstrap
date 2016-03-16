#!/bin/bash
source "$(dirname "$0")/bs.sh"

since_last=$(($(date +%s)-$(stat -c %Y /var/cache/apt/)))
# Ten minutes
if [ $since_last -gt 600 ] ; then
    default=y
else
    default=n
fi

prompt_step "Update packages now?" $default

apt-get update
apt-get upgrade
apt-get autoremove --purge
apt-get autoclean
