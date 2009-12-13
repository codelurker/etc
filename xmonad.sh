#!/bin/bash

trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --height 12 --transparent true --tint 0x000000 &
gnome-settings-daemon &
gnome-power-manager &
nm-applet &
nautilus &

exec xmonad
