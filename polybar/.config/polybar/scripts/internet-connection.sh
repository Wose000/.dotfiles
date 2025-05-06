#!/bin/bash

ping -c 1 8.8.8.8 > /dev/null 2>&1

if [ $? -eq 0 ]; then
	echo "󰖟"
else
	echo "%{F#404847}󰪎%{F-}"
fi
