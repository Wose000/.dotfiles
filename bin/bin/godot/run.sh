#!/usr/bin/env bash

# config in editor:
# exec path: /bin/zsh
# exec flags: -c "source ~/.zshrc && ~/bin/run.sh {project} ~/.cache/nvim/godot-$(basename {project}).socket {file} {line} {col}"

TERM_EXEC="wezterm start --"

notify-send "PORCO DIO"
if [ $# -ne 5 ]; then
    echo "USAGE: $0 <project dir> <socket> <file> <line> <column>"
    exit 1
fi
PROJECT_DIR="$1"
SOCKET="$2"
FILE="$3"
LINE="$4"
COL="$5"

PROJECT_NAME=$(basename "$PROJECT_DIR")

# Function to wait for socket to be available
wait_for_socket() {
    local socket="$1"
    local timeout=10
    local count=0

    while [ ! -S "$socket" ] && [ $count -lt $timeout ]; do
        sleep 0.5
        count=$((count + 1))
    done

    return $count
}

# Check if socket exists and try to connect first
if [ -S "$SOCKET" ]; then
    nvim --server "$SOCKET" --remote-send ":n +call\ cursor($LINE,$COL) $FILE<CR>"
else
    # Check if tmux session with project name exists
    if tmux has-session -t "$PROJECT_NAME" 2>/dev/null; then
        # Session exists - attach to it and open nvim
        if tty -s; then
            # We're in a terminal, attach directly
            tmux attach-session -t "$PROJECT_NAME" \; send-keys "cd '$PROJECT_DIR' && nvim --listen '$SOCKET'" C-m
        else
            # Not in terminal, open new terminal and attach
            nohup $TERM_EXEC tmux attach-session -t "$PROJECT_NAME" \; send-keys "cd '$PROJECT_DIR' && nvim --listen '$SOCKET'" C-m >/dev/null 2>&1 &
        fi
    else
        # Session doesn't exist - create new one
        if tty -s; then
            # We're in a terminal, create session directly
            tmux new-session -d -s "$PROJECT_NAME" -c "$PROJECT_DIR" "nvim --listen '$SOCKET'"
            tmux attach-session -t "$PROJECT_NAME"
        else
            # Not in terminal, open new terminal with new tmux session
            nohup $TERM_EXEC tmux new-session -s "$PROJECT_NAME" -c "$PROJECT_DIR" "nvim --listen '$SOCKET'" >/dev/null 2>&1 &
        fi
    fi
    # Wait for socket to be ready
    wait_for_socket "$SOCKET"
    # First restore session, then open the file
    nvim --server "$SOCKET" --remote-send ":lua require('mini.sessions').read('$PROJECT_NAME')<CR>"
    sleep 0.2 # Small delay to ensure session is loaded
    nvim --server "$SOCKET" --remote-send ":n +call\ cursor($LINE,$COL) $FILE<CR>"
fi
