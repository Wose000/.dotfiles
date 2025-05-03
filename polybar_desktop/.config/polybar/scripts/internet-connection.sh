#!/bin/bash

ping -c 1 8.8.8.8 > /dev/null 2>&1
CONNECTION=0

if [ $? -eq 0 ]; then
	echo "%{F#08ce81}󰖟%{F-}"
else
	echo "󰪎"
fi
