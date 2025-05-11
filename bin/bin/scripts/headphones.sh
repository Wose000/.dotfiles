#!/bin/env bash

CURRENT_HOST=$(cat /etc/hostname)

# ICONS
HEADPHONES="󰋋"
SPEAKERS="󰟎"

regex() {
    # Usage: regex "string" "regex"
    [[ $1 =~ $2 ]] && printf '%s\n' "${BASH_REMATCH[1]}"
}
ACTIVE_PROFILE=$(regex "$(pactl list cards | grep "Active")" '^\s*Active Profile: (.*)')
HEADPHONES_PROFILE="HiFi (HDMI1, HDMI2, HDMI3, Headphones, Mic1, Mic2)"
SPEAKERS_PROFILE="HiFi (HDMI1, HDMI2, HDMI3, Mic1, Mic2, Speaker)"
CARD_NAME="alsa_card.pci-0000_00_1f.3-platform-skl_hda_dsp_generic"

  # pactl sinks
DEFAULT_SINK="alsa_output.pci-0000_00_1f.3.analog-stereo"
ACTIVE_SINK=$( pactl get-default-sink )
ACTIVE_PORT=$(pactl list sinks | grep "Active Port: analog-output"| cut -d: -f2- | xargs)
PORT_HEADPHONES="analog-output-headphones"
PORT_SPEAKERS="analog-output-lineout"

set_correct_sink() {
	if [[ $DEFAULT_SINK != $ACTIVE_SINK ]]; then
		echo "This is not the usual sink"
		pactl set-default-sink $DEFAULT_SINK
	fi
}

set_correct_icon() {
	if [[ "$ACTIVE_PORT" == "$PORT_HEADPHONES" || "$ACTIVE_PROFILE" == "$HEADPHONES_PROFILE" ]]; then
		echo $HEADPHONES
  else
		echo $SPEAKERS
	fi 
}

if [[ $CURRENT_HOST == "arch-pc" ]]; then

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
elif [[ "$CURRENT_HOST" == "arch-laptop" ]]; then
  case "$1" in
  --toggle)
    if [[ "$ACTIVE_PROFILE" == "$HEADPHONES_PROFILE" ]]; then
  # if the active port is headphones set it to be speakers
      pactl set-card-profile "$CARD_NAME" "$SPEAKERS_PROFILE"
      echo "$SPEAKERS"
    elif [[ "$ACTIVE_PROFILE" == "$SPEAKERS_PROFILE" ]]; then
  # if the audio is being played by the speakers set it to the headphones
      pactl set-card-profile "$CARD_NAME" "$HEADPHONES_PROFILE"
      echo "$HEADPHONES"
    fi 
    ;;
  *)
    set_correct_icon
    ;;
  esac
fi
