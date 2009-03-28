#!/bin/bash

# Load resources
xrdb -merge ~/.Xdefaults

# Remap CapsLock to Ctrl
xmodmap ~/.xmodmap

# Setup icon tray
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --tint black --transparent true --height 10 &

# Set root window
xsetroot -solid darkslategray

# Fire up some apps

if [ -x /usr/bin/nm-applet ] ; then
   nm-applet --sm-disable &
fi
 
if [ -x /usr/bin/gnome-power-manager ] ; then
   sleep 3
   gnome-power-manager
fi

if [ -x /usr/bin/gnome-screensaver ] ; then
   gnome-screensaver &
fi

urxvt &

# Start the window manager
exec /usr/bin/xmonad
