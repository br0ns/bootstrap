#!/bin/bash
source "$(dirname "$0")/bootstrap"

prompt_install dbus-dummy

require equivs

goto_tempdir

cat > dbus-dummy-control <<EOF
Section: misc
Priority: optional
Standards-Version: 3.9.2

Package: dbus-dummy
Version: 1.0
Maintainer: br0ns <f@ntast.dk>
Provides: dbus, dbus-x11
Architecture: all
Description: Empty package providing \`dbus' and \`dbus-x11'.
EOF

run equivs-build dbus-dummy-control
run sudo dpkg --install dbus-dummy_1.0_all.deb
