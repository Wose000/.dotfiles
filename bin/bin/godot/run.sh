#!/usr/bin/env bash

# --- CONFIG ---
term_exec="wezterm"                            # terminal emulator
nvim_exec="nvim"                               # neovim executable
server_path="$HOME/.cache/nvim/godot-server.pipe"
server_startup_delay=0.1                       # wait time if server just started
# --------------

start_server() {
    "$term_exec" -e "$nvim_exec" --listen "$server_path" &
    sleep "$server_startup_delay"
}

open_file_in_server() {
    local filename="$1"
    local line="$2"
    # Escape filename for Neovim remote command
    filename=$(printf %q "$filename")

    "$term_exec" -e "$nvim_exec" \
        --server "$server_path" \
        --remote-send "<C-\\><C-n>:e $filename<CR>:call cursor($line,1)<CR>"
}

# --- MAIN ---
if ! [ -e "$server_path" ]; then
    start_server
fi

open_file_in_server "$1" "$2"
