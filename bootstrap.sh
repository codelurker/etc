#!/bin/bash
#
# Small script to setup my environment on a new machine

function safe_link {
    from=$1
    to=$2
    if [[ -e $to ]] ; then
        backup=${to}.orig
        cp $to $backup
        rm $to
        echo "Backed up $to to $backup"
    fi
    ln -s $from $to
    echo "Linked $from to $to"
}

# Install dot-files
for f in xmodmap xsession Xdefaults zshrc xmobarrc ls-colors; do
    safe_link ~/etc/$f ~/.$f
done

# Install script files
mkdir -p ~/scripts
for s in xmonad.sh sshmenu pychecker.sh; do 
    safe_link ~/etc/$s ~/scripts/$s
done

# Install XMonad config
mkdir -p ~/.xmonad
safe_link ~/etc/xmonad.hs ~/.xmonad/xmonad.hs

# Other misc files
safe_link ~/etc/dot-sshmenu ~/.sshmenu
