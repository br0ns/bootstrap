#!/bin/bash
source "$(dirname "$0")/bs.sh"

cat > .config/Trolltech.conf <<EOF
[Qt]
style=GTK+
EOF

[ -e /usr/share/themes/Materia/ ] && exit 0

prompt_step "Materia GTK theme is not installed; Download and install now?" "y"

require gnome-themes-standard libglib2.0-dev gtk2-engines-murrine

goto_tempdir

curl -sL https://github.com/nana-4/materia-theme/archive/master.tar.gz | tar xz
cd materia-theme-master
sudo ./install.sh

chromium "file://$PWD/src/chrome/Materia-dark Theme.crx"
