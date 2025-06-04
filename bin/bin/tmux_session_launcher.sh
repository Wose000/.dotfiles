#!/bin/bash

attach_or_switch() {
	if [ -z "$TMUX" ]; then
		# not in tmux
		tmux attach-session -t $1
	else
		# inside tmux
		tmux switch-client -t $1
	fi
}

get_folder_name() {
  path_without_trailing_slash="${1%/}"
  echo "${path_without_trailing_slash##*/}"
}

sessions_folders=(
  "$HOME/m/prj/"
  "$HOME/m/src/"
  "$HOME/.dotfiles/"
)

sessions_path=(
  "$HOME"
  "$HOME/m/doc/note/"
  "$HOME/.dotfiles/"
  )

session_folder="$( { fd -d 1 -t d . "${sessions_folders[@]}"; printf '%s\n' "${sessions_path[@]}"; }| fzf)"

echo "$session_folder"

session_name="$(get_folder_name "$session_folder")"

echo "$session_name"
tmux has-session -t $session_name 2>/dev/null

if [ $? != 0 ]; then
	tmux new-session -d -s $session_name -c $session_folder -n 'Nvim'
fi

attach_or_switch "$session_name"

