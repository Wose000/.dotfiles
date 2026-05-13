#!/bin/env bash

SESSION="ctrl-panel"
WINDOW="$SESSION":0
BTOP_WIN="$WINDOW".0
BLUETUI_WIN="$WINDOW".1
WIFI_WIN="$WINDOW".2

SESSIION_EXIST=$(tmux list-sessions | grep "$SESSION")

open_session() {
    tmux new-session -d -s $SESSION
    tmux splitw -h -t $BTOP_WIN
    tmux splitw -v -t $BLUETUI_WIN
    tmux send-keys -t $BTOP_WIN C-z 'btop' Enter
    tmux send-keys -t $BLUETUI_WIN C-z 'bluetui' Enter
    tmux attach-session -t $SESSION
}

if [[ "$SESSIION_EXIST" == "" ]]; then
    open_session
else
    tmux attach-session -t $SESSION
fi
