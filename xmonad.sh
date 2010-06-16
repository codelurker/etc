#!/bin/bash

xrdb -merge ~/.Xdefaults
xmodmap ~/.xmodmap

gnome-settings-daemon &
gnome-power-manager &
gnome-screensaver &
nm-applet &
dropbox start &
gnome-panel &

exec /usr/bin/xmonad
