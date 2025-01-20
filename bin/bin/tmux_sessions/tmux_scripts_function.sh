#!/bin/env bash

attach_or_switch() {
	if [ -z "$TMUX" ]; then
		# not in tmux
		tmux attach-session -t $1
	else
		# inside tmux
		tmux switch-client -t $1
	fi
}

