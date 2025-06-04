#!/bin/bash

LOCAL_REPO_PATH="$HOME/m/prj/pathfinder_v1"
CLONE_TMP="$HOME/m/tmp"
RCLONE_REMOTE="onedrive:Code/pathfinder_v1"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

if [[ -d $CLONE_TMP ]]; then
	echo "Removing old clone ad $CLONE_TMP"
	rm -rf "$CLONE_TMP"
fi

echo "Cloning repository from $LOCAL_REPO_PATH..."
git clone "$LOCAL_REPO_PATH" "$CLONE_TMP"

echo "Backing up clone to $RCLONE_REMOTE/$TIMESTAMP"
rclone copy --links "$CLONE_TMP" "$RCLONE_REMOTE/$TIMESTAMP"

echo "Backup completed sucessfully..."
