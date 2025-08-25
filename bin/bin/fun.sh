#!/bin/env bash

gfp(){
	git add .
	git commit -m "fast push"
	git push origin main
}

mod() {

	rclone --vfs-cache-mode writes mount "onedrive": ~/mnt/onedrive/
}
