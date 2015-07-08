#!/bin/bash
source "$(dirname "$0")/bootstrap"

# little hack here -- this package will not install anything so we check for it
# here and then use `prompt_install' with a path that will never exist

if dpkg --status $pkg >/dev/null 2>&1 ; then
    OK dbus-dummy
    exit 0
fi

prompt_install /this/will/never/exist dbus-dummy

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
