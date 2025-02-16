#!/bin/env bash

DEVICE_NAME="Tablet Monitor Pen Pen"

OUTPUT="DP-3"

export DISPLAY=:0
export XAUTHORITY=/home/wose/.Xauthority

while true; do
	DEVICE_ID=$(xinput list | grep -i "$DEVICE_NAME" | grep -o 'id=[0-9]*' | cut -d= -f2)
	if [ -n "$DEVICE_ID" ]; then
		xinput map-to-output "$DEVICE_ID" "$OUTPUT"
		break
	fi
	sleep 1
done

