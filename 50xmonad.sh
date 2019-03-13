#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install xmonad XMonad

require \
    ghc cabal-install zlib1g-dev libx11-dev libxinerama-dev libxrandr-dev \
    libxft-dev libpcre3-dev libxss-dev

INFO Updating cabal
cabal update

if [ ! -f ".cabal/bin/cabal" ] ; then
    echo "Installing cabal-install in user dir"
    cabal install cabal-install
fi

INFO Installing XMonad
cabal install xmonad
cabal install xmonad-contrib

# My XMonad configuration needs this package
cabal install regex-pcre

# Compile `blink' to alert me of IRC activity
sudo gcc .xmonad/blink.c -o .xmonad/blink
sudo chmod u+s .xmonad/blink

# Compile `suspend' to lock the screen and suspend the computer
sudo gcc .xmonad/suspend.c -o .xmonad/suspend
sudo chmod u+s .xmonad/suspend

# Compile `brightness' to control panel brightness
sudo gcc .xmonad/brightness.c -o .xmonad/brightness
sudo chmod u+s .xmonad/brightness

# Update PATH maybe?
[ -f ~/.profile ] && . ~/.profile

assert installed xmonad
