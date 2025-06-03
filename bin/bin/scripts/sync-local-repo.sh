
#!/bin/env bash

# === CONFIGURATION ===
LOCAL_REPO_PATH="$HOME/projects/my-repo"          # Path to your local Git repo
CLONE_DEST="$HOME/tmp/my-repo-clone"              # Temporary clone location
RCLONE_REMOTE="onedrive:Backup/my-repo"           # rclone remote target
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")                # Timestamp for backup folder

# === CLEANUP OLD CLONE ===

if [ -d "$CLONE_DEST" ]; then
    echo "Removing old clone at $CLONE_DEST..."
    rm -rf "$CLONE_DEST"
fi

# === CLONE REPO LOCALLY ===
echo "Cloning repository from $LOCAL_REPO_PATH..."
git clone "$LOCAL_REPO_PATH" "$CLONE_DEST"

# === BACKUP WITH RCLONE ===
echo "Backing up clone to $RCLONE_REMOTE/$TIMESTAMP..."
rclone copy --links "$CLONE_DEST" "$RCLONE_REMOTE/$TIMESTAMP"

# === DONE ===
echo "Backup completed successfully!"
