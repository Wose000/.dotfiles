#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
		done
		unset f
fi

export HOSTNAME=$(cat /etc/hostname)
setxkbmap -option caps:hyper

exec awesome

