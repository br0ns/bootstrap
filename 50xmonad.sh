#!/bin/bash
source "$(dirname "$0")/bootstrap"

prompt_install xmonad XMonad

require \
    ghc cabal-install zlib1g-dev libx11-dev libxinerama-dev libxrandr-dev \
    libxft-dev libpcre3-dev

INFO Updating cabal
run cabal update

if [ ! -f ".cabal/bin/cabal" ] ; then
    echo "Installing cabal-install in user dir"
    run cabal install cabal-install
fi

INFO Installing XMonad
run cabal install xmonad

# Currently version 0.11.4 does not compile with latest GHC...
run cabal install xmonad-contrib-0.11.3

# My XMonad configuration needs this package
run cabal install regex-pcre

# Compile `blink' to alert me of IRC activity
run sudo gcc .xmonad/blink.c -o .xmonad/blink
run sudo chmod u+s .xmonad/blink

# Compile `suspend' to lock the screen and suspend the computer
run sudo gcc .xmonad/suspend.c -o .xmonad/suspend
run sudo chmod u+s .xmonad/suspend

# Update PATH maybe?
[ -f ~/.profile ] && . ~/.profile

assert installed xmonad
