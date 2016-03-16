#!/bin/bash
source "$(dirname "$0")/bs.sh"

for f in /bin/mount \
             /bin/ping6 \
             /bin/su \
             /bin/umount \
             /sbin/pam_extrausers_chkpwd \
             /sbin/unix_chkpwd \
             /usr/bin/bsd-write \
             /usr/bin/chage \
             /usr/bin/chfn \
             /usr/bin/chsh \
             /usr/bin/dotlockfile \
             /usr/bin/expiry \
             /usr/bin/gpasswd \
             /usr/bin/passwd \
             /usr/bin/ssh-agent \
             /usr/bin/wall \
             /usr/bin/X \
             /usr/lib/emacs/*/x86_64-linux-gnu/movemail \
             /usr/lib/libvte-*/gnome-pty-helper \
             /usr/lib/openssh/ssh-keysign \
             /usr/lib/pt_chown \
         ; do
    if [ -e $f ] ; then
        sudo chmod -s $f
    fi
done

sudo setcap -r /usr/bin/systemd-detect-virt 2>/dev/null || true
sudo setcap -r /usr/lib/x86_64-linux-gnu/gstreamer*/gstreamer-*/gst-ptp-helper 2>/dev/null || true

# sudo find / \( -path /var/lib/docker -prune \) -o -type f -perm /6000 -ls 2>/dev/null
# sudo find / \( -path /var/lib/docker -prune \) -o -type f -perm /0111 -exec getcap {} + 2>/dev/null
