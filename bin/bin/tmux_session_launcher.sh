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

# array with folders to search associated to their needed --exact-depth for fd.
declare -A folder_depths=(
    ["$HOME/m/prj/"]=1
    ["$HOME/m/src/"]=1
    ["$HOME/.dotfiles/"]=3
)

# array of paths to add singularly without the need of fd
sessions_path=(
    "$HOME"
    "$HOME/m/doc/note/"
    "$HOME/.dotfiles/"
    "$HOME/m/pathfinder/pathfinder_vault/"
)

# array to fill with all the paths to select from
all_paths=()

# populate all_paths
for folder in "${!folder_depths[@]}"; do
    depth="${folder_depths[$folder]}"
    while IFS= read -r path; do
        all_paths+=("$path")
    done < <(fd --exact-depth "$depth" -t d . "$folder")
done

all_paths+=("${sessions_path[@]}")

selected_folder="$(printf '%s\n' "${all_paths[@]}" | fzf)"

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

