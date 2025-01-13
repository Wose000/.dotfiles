#!/bin/zsh


if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
	exec startx
fi

export EDITOR=nvim
