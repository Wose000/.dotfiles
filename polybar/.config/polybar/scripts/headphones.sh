#!/bin/env bash

# PORTS

ACTIVE_PORT=$(pactl list sinks | grep "Active Port: analog-output"| cut -d: -f2- | xargs)
PORT_HEADPHONES="analog-output-headphones"
PORT_SPEAKERS="analog-output-lineout"

# ICONS
HEADPHONES="󰋋"
SPEAKERS="󰟎"
# pactl sinks
DEFAULT_SINK="alsa_output.pci-0000_00_1f.3.analog-stereo"
ACTIVE_SINK=$( pactl get-default-sink )


set_correct_sink() {
	if [[ $DEFAULT_SINK != $ACTIVE_SINK ]]; then
		echo "This is not the usual sink"
		pactl set-default-sink $DEFAULT_SINK
	fi
}

set_correct_icon() {
	if [ "$ACTIVE_PORT" == "$PORT_HEADPHONES" ]; then
		echo $HEADPHONES
	elif [ "$ACTIVE_PORT" == "$PORT_SPEAKERS" ]; then
		echo $SPEAKERS
	fi 
}

set_correct_sink

case "$1" in
--toggle)
	if [[ "$ACTIVE_PORT" == "$PORT_HEADPHONES" ]]; then
# if the active port is headphones set it to be speakers
		pactl set-sink-port $DEFAULT_SINK $PORT_SPEAKERS
		set_correct_icon
	elif [[ "$ACTIVE_PORT" == "$PORT_SPEAKERS" ]]; then
# if the audio is being played by the speakers set it to the headphones
		pactl set-sink-port $DEFAULT_SINK $PORT_HEADPHONES
		set_correct_icon
	fi 
	;;
*)
	set_correct_icon
	;;
esac

