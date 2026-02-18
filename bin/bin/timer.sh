#!/bin/env bash
SHORT_BREAK=300  # 5-minute break
ALARM_FILE="$HOME/bin/data/mixkit-classic-alarm-995.wav"


if [[ $1 -gt 0 ]]; then
  notify-send "$1 min timer started"
  sleep $(( $1 * 60 ))
else
  notify-send "Default 5 minutes timer started"
fi

paplay "$ALARM_FILE"
