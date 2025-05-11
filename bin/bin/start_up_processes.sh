#!/bin/bash


killall -q dunst
dunst &
killall -q picom 
picom &
killall -q greenclip
greenclip daemon &
