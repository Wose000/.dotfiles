#!/bin/bash

MAIN_DIR=$(pwd)
echo $MAIN_DIR

cd  $HOME/.dotfiles/nvim/dot-config/nvim/
git add .
git commit -m "fast update"
git push origin main

cd $HOME/.dotfiles

git add .
git commit -m "fast update"
git push origin main
