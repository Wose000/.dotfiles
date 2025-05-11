#!/bin/env bash

test(){
  if [[ $(xrandr --listactivemonitors | grep "$1") == $2 ]]; then
    return 0
  fi
}

MAIN="DP-0"
PEN="DP-3"
SECOND="HDMI-0"

FIRST_OK=" 0: +*DP-0 1920/532x1080/304+1920+0  DP-0"
SECOND_OK=" 2: +HDMI-0 1920/527x1080/296+0+0  HDMI-0"
PEN_OK=" 1: +DP-3 1920/432x1080/243+3840+0  DP-3"


if test "$MAIN" "$FIRST_OK" && test "$SECOND" "$SECOND_OK" && test "$PEN" "$PEN_OK"; then
  echo "monitors ok"
else
  xrandr --output $MAIN --mode 1920x1080 --rate 143 --pos 0x0 --primary --output $SECOND --mode 1920x1080 --left-of $MAIN --output $PEN --mode 1920x1080 --right-of $MAIN
fi
