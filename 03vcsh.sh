#!/bin/bash
source "$(dirname "$0")/bootstrap"

echo "Checking VCSH repositories"
REPOS="bash emacs gdb git gtk misc pkgs secret xconfig xmonad"
DOASKPULL=0
for repo in $REPOS ; do
    if vcsh status $repo >/dev/null 2>&1 ; then
        if [ $DOASKPULL -eq 0 ] ; then
            if promptyn "Do \`pull' for existing repositories?" "y" ; then
                DOPULL=0
            else
                DOPULL=1
            fi
            DOASKPULL=1
        fi
        OK $repo
        if [ $DOPULL -eq 0 ] ; then
            run "vcsh $repo pull"
        fi
    else
        INFO Cloning $repo
        run "vcsh clone git@github.com:br0ns/vcsh-$repo.git $repo"
        run "vcsh $repo checkout master -f"
    fi
    assert [ -d ".config/vcsh/repo.d/$repo.git" ]
done
