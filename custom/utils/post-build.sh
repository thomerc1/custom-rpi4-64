#!/bin/sh

# Script that runs following source build and prior to image generation


# The first argument to the post-build script is the path to the target root filesystem
TARGET_ROOTFS_DIR="$1"


# Update sshd_config to allow root login
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' "$TARGET_ROOTFS_DIR/etc/ssh/sshd_config"


# Add lines to board config
file_path="board/raspberrypi4-64/config_4_64bit.txt"
lines_to_add="# Mimic hotplug to not require HDMI when running headless
hdmi_force_hotplug=1
hdmi_ignore_edid=0xa5000080"
# Adds lines if they don't exist
printf "%s\n" "$lines_to_add" | while IFS= read -r line; do
    if ! grep -q "^$line$" "$file_path"; then
        # Line doesn't exist, so append it to the file
        echo "$line" >> "$file_path"
    fi
done


# Add project git commit version to /etc/commit_version file if project is a git project
# Define the output file
VERSION_FILE="$TARGET_ROOTFS_DIR/etc/commit_version"
# Attempt to get the root directory of the Git repository
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ $? -eq 0 ]; then
    # If the previous command succeeded, we're in a Git repository.
    # Get the short commit hash
    COMMIT_HASH=$(git -C "$GIT_ROOT" rev-parse --short HEAD)
    # Write the commit hash to the output file
    echo "$COMMIT_HASH" > "$VERSION_FILE"
else
    # If the previous command failed, we're not in a Git repository.
    echo "Not a Git repository" > "$VERSION_FILE"
fi

