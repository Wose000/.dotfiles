#!/bin/env bash

DEVICE_NAME="Tablet Monitor Pen Pen"

OUTPUT="DP-3"

export DISPLAY=:0
export XAUTHORITY=/home/wose/.Xauthority

udevadm monitor --subsystem-match=input | while read -r line; do
	if xinput list | grep -i "$DEVICE_NAME"; then
		DEVICE_ID=$(xinput list | grep -i "$DEVICE_NAME" | grep -o 'id=[0-9]*' | cut -d= -f2)
		if [ -n "$DEVICE_ID" ]; then
			echo "$DEVICE_ID"
			xinput map-to-output "$DEVICE_ID" "$OUTPUT"
			killall udevadm
			break
		fi
	fi
done

