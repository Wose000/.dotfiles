#!/bin/env bash

SESSION="srvr"

tmux has-session -t $SESSION 2>/dev/null

if [ $? != 0 ]; then
				tmux new-session -d -s $SESSION

				tmux rename-window -t 0 'Main'
				tmux send-keys -t 'Main' 'zsh' C-m 'clear' C-m 'cd /home/wose/prj/python/srvclnt/' C-m

				# Create pane for server
				tmux new-window -t $SESSION:1 -n 'Server'
				tmux send-keys -t 'Server' 'python /home/wose/prj/python/srvclnt/server.py' C-m

				# Setup neovim for the session
				tmux new-window -t $SESSION:2 -n 'Neovim'
				tmux send-keys -t 'Neovim' "cd ~/prj/python/srvclnt/" C-m "nvim" C-m
fi


tmux attach-session -t $SESSION:0
