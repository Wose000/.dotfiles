#!/bin/env bash

gfp(){
    git add .
    git commit -m "fast push"
    git push origin main
}

mod() {

    rclone --vfs-cache-mode writes mount "onedrive": ~/mnt/onedrive/
}

function y() {
    local tmp="$(mktemp  -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}
