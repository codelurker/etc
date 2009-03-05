#!/bin/bash

# Load resources
xrdb -merge ~/.Xdefaults

# Remap CapsLock to Ctrl
xmodmap ~/.xmodmap

# Setup icon tray
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x191970 --height 12 &

# Fire up some apps
nm-applet --sm-disable &
gnome-power-manager &
gnome-screensaver &
urxvt &

# Start the window manager
exec /usr/bin/xmonad
