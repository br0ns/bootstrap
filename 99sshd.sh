#!/bin/bash
source "$(dirname "$0")/bs.sh"

cd /etc/ssh

if [[ "$(head -n 1 sshd_config)" != "# OK" ]] ; then
    INFO Configuring SSHd
    # Install config
    sudo mv sshd_config sshd_config.bak
    sudo tee sshd_config <<EOF
# OK
Port 22

Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

UsePrivilegeSeparation yes

ServerKeyBits 2024
LoginGraceTime 120
KeyRegenerationInterval 3600

PermitRootLogin no
IgnoreRhosts yes
IgnoreUserKnownHosts yes
StrictModes yes

X11Forwarding no
PrintMotd no
PrintLastLog no

SyslogFacility AUTH
LogLevel INFO

RhostsAuthentication no
RhostsRSAAuthentication no
RSAAuthentication no
ChallengeResponseAuthentication no
HostbasedAuthentication no
PasswordAuthentication no
PubkeyAuthentication yes

PermitEmptyPasswords no

UsePAM yes

UseDNS no

TCPKeepAlive yes
EOF
    # Regenerate host keys
    sudo rm -f ssh_host_*_key
    sudo rm -f ssh_host_*_key.pub
    sudo dpkg-reconfigure openssh-server

    # Restart server
    sudo /etc/init.d/ssh restart
fi
