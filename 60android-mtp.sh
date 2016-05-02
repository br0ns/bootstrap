#!/bin/bash
source "$(dirname "$0")/bs.sh"

require android-tools-adb jmtpfs

[ -e /etc/udev/rules.d/51-android.rules ] && exit 0

INFO Installing udev rules for Android phones

sudo wget --header='Accept-Encoding:none' -O /etc/udev/rules.d/51-android.rules \
     https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/android/51-android.rules
sudo chmod a+r /etc/udev/rules.d/51-android.rules

sudo wget --header='Accept-Encoding:none' -O /etc/udev/rules.d/69-mtp.rules \
     https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/android/69-mtp.rules
sudo chmod a+r /etc/udev/rules.d/69-mtp.rules

INFO Restarting udev daemon
sudo service udev restart

mkdir -p ~/.android/
echo "0x2a70" >> ~/.android/adb_usb.ini

INFO Restarting ADB
adb kill-server | true
adb start-server
