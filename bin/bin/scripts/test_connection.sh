#!/bin/env bash

if ping -c 1 -W 2 8.8.8.8 >&/dev/null; then
  echo "Internet up, update dotfiles"
else
  echo "No internet connection available skip updates.."
fi
