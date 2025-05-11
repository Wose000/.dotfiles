#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
		done
		unset f
fi

export HOSTNAME=$(cat /etc/hostname)

if [[ $HOSTNAME == "arch-pc" ]]; then

MAIN="DP-0"
PEN="DP-3"
SECOND="HDMI-0"
  xrandr --output $MAIN --mode 1920x1080 --rate 143 --pos 0x0 --primary --output $SECOND --mode 1920x1080 --left-of $MAIN --output $PEN --mode 1920x1080 --right-of $MAIN
fi

setxkbmap -option caps:hyper

exec awesome

