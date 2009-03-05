#!/bin/bash
#
# Small script to setup my environment on a new machine

for f in xmodmap xsession Xdefaults zshrc xmobarrc; do
    if [[ -e ~/.${f} ]] ; then
        mv ~/.${f} ~/.${f}.orig
        ln -s ~/etc/${f} ~/.${f}
    fi
done

if [[ -d ~/.xmonad ]] ; then
    mv ~/.xmonad/xmonad.hs ~/.xmonad/xmonad.hs.orig
    ln -s ~/etc/xmonad.hs ~/.xmonad/xmonad.hs
fi
