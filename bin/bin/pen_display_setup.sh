#!/bin/env bash

DEVICE_NAME="Tablet Monitor Pen Pen"

DISPLAY="DP-3"

udevadm monitor --subsystem-match=input | while read -r line; do
	if xinput list | grep -i "$DEVICE_NAME"; then
		DEVICE_ID=$(xinput list | grep -i "$DEVICE_NAME" | grep -o 'id=[0-9]*' | cut -d= -f2)
		if [ -n "$DISPLAY" ]; then
			xinput map-to-output "$DEVICE_ID" "$DISPLAY"
			break
		fi
	fi
done
