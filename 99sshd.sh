#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_configure /etc/ssh/sshd_config

cd /etc/ssh

INFO Configuring SSHd
# Install config
sudo mv sshd_config sshd_config.bak
sudo tee sshd_config <<EOF
# $BS_MARK
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

OK

# Regenerate host keys
if promptyn "Regenerate host keys?" "y" ; then
    sudo rm -f ssh_host_*_key
    sudo rm -f ssh_host_*_key.pub
    sudo dpkg-reconfigure openssh-server
fi

# Restart server
sudo /etc/init.d/ssh restart
