#!/bin/bash

MAIN_DIR=$(pwd)
echo $MAIN_DIR

cd ./nvim/.config/nvim/
git add .
git commit -m "fast update"
git push origin main

cd "$MAIN_DIR"

git add .
git commit -m "fast update"
git push origin main
