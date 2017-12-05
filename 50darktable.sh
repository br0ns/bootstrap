#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install darktable "Darktable"

require git cmake intltool libcurl4-openssl-dev libexiv2-dev libgphoto2-dev \
        libgtk-3-dev libjson-glib-dev liblcms2-dev liblensfun-dev \
        libopenexr-dev libpugixml-dev librsvg2-dev libsqlite3-dev libtiff5-dev \
        libwebp-dev libxml2-dev libxml2-utils xsltproc

goto_tempdir

git clone https://github.com/darktable-org/darktable.git .
git submodule init
git submodule update

./build.sh --prefix /opt/darktable --build-type Release --sudo --install
