#!/bin/bash
source "$(dirname "$0")/bs.sh"

# Things that I usually forget how to do but can't easily automate

INFO "[Install printer]

Add yourself to the lpadmin group:

  $ sudo usermod -aG lpadmin <username>

Then go to http://localhost:631 and add the printer.
"

INFO "[Audio]

Check the available sound cards in /proc/asound/cards:

  $ cat /proc/asound/cards
   0 [HDMI           ]: HDA-Intel - HDA Intel HDMI
                        HDA Intel HDMI at 0xf723c000 irq 52
   1 [PCH            ]: HDA-Intel - HDA Intel PCH
                        HDA Intel PCH at 0xf7238000 irq 49

Then set the order in a .conf file in /etc/modprobe.d:

  $ cat /etc/modprobe.d/alsa-base.conf
  options snd_hda_intel enable=1,0
"

INFO "[Phone]

Mount:

  $ jmtpfs <mountpoint>

Unmount:

  $ fusermount -u <mountpoint>
"
