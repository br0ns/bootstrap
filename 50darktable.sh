#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install darktable "Darktable"

require git xsltproc libxml2-utils intltool libpugixml-dev libgtk-3-dev libxml2-dev libgphoto2-dev libopenexr-dev libwebp-dev liblensfun-dev librsvg2-dev libsqlite3-dev libcurl4-openssl-dev libtiff5-dev liblcms2-dev libjson-glib-dev libexiv2-dev

goto_tempdir

git clone https://github.com/darktable-org/darktable.git .
git submodule init
git submodule update
