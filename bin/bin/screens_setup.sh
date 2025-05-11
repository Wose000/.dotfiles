#!/bin/sh

MAIN_MONITOR="DP-0"
PEN_MONITOR="DP-3"
SECOND_MONITOR="HDMI-0"


if [[ -n $(xrandr --listactivemonitors | grep "eDP-1") ]]; then
	# LAPTOP CONFIG
	bspc monitor -d 1 2 3 4 5 6 7
else
	# DESKTOP CONFIG
	### WORKSPACES ###
	bspc monitor $MAIN_MONITOR -d nvim obs util
	bspc monitor $SECOND_MONITOR -d web term extra
	bspc monitor $PEN_MONITOR -d draw

	### CONFIGURATION ###
	bspc config remove_disabled_monitors true
	bspc config remove_unplugged_monitors true


	xrandr --output $MAIN_MONITOR --mode 1920x1080 --rate 143 --pos 0x0 --primary --output $SECOND_MONITOR --mode 1920x1080 --left-of $MAIN_MONITOR --output $PEN_MONITOR --mode 1920x1080 --right-of $MAIN_MONITOR

fi
