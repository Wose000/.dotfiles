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

get_folder_name() {
    path_without_trailing_slash="${1%/}"
    basename="${path_without_trailing_slash##*/}"
    echo "${basename//./}"
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
    "$HOME/m/pathfinder/pathfinder_vault/"
)

selected_folder="$( { fd -d 1 -t d . "${sessions_folders[@]}"; printf '%s\n' "${sessions_path[@]}"; }| fzf)"

if [[ -z $selected_folder ]]; then
    echo "No solection"
    exit 0
fi

session_name="$(get_folder_name "$selected_folder")"

if ! tmux has-session -t $session_name 2>/dev/null; then
    echo ok
    tmux new-session -d -s "$session_name" -c "$selected_folder" -n 'Nvim'
fi

attach_or_switch "$session_name"

