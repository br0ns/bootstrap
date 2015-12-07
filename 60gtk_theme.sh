#!/bin/bash
source "$(dirname "$0")/bs.sh"

[ -e /usr/share/themes/FlatStudio/ ] && exit 0

prompt_step "FlatStudio GTK theme is not installed; Download and install now?" "y"

goto_tempdir

wget http://gnome-look.org/CONTENT/content-files/154296-FlatStudio-1.03.tar.gz -O flatstudio.tgz
sudo tar xfv flatstudio.tgz -C /usr/share/themes/

.config/Trolltech.conf <<EOF
[Qt]
style=GTK+
EOF
