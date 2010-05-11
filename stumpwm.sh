#!/bin/bash

xrdb -merge ~/.Xdefaults
xmodmap ~/.xmodmap

#trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --height 12 --transparent true --tint 0x000000 --alpha 0 &
gnome-settings-daemon &
gnome-power-manager &
gnome-screensaver &
nm-applet &
nautilus &
dropbox start

exec /usr/local/bin/stumpwm
