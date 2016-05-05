#!/bin/bash
source "$(dirname "$0")/bs.sh"

since_last=$(($(date +%s)-$(stat -c %Y /var/cache/apt/)))
# Default to "yes" if at least ten minutes since last update or sources.list has
# been updated
if [ $since_last -gt 600 ] || \
       [ /var/cache/apt/ -ot /etc/apt/sources.list ] ; then
    default=y
else
    default=n
fi

prompt_step "Update packages now?" $default

apt-get update
apt-get upgrade
apt-get autoremove --purge
apt-get autoclean
