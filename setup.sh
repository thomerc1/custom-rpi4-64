#!/bin/sh

# Set buildroot dir from arg passed to script
BUILDROOT_DIR="$1"
PROJECT_DIR=$(pwd)

# Verify script caller passed in buildroot dir
if [ "$#" -ne 1 ] || [ ! -d "$BUILDROOT_DIR" ] || [ ! -f "$BUILDROOT_DIR/Makefile" ]; then
    echo "Usage: $0 <path_to_buildroot_directory>"
    echo "Error: Directory does not exist or is not a valid Buildroot directory"
    exit 1
fi

# Setup environment
EXT_DESC_FILE="external.desc"
touch Config.in
touch external.mk
touch $EXT_DESC_FILE 

# Add lines to external.desc file if not already there 
EXT_DESC_LINE1="name: custom_rpi4_64"
EXT_DESC_LINE2="desc: Custom package for Raspberry Pi 4 64-bit"
if ! grep -Fxq "$LINE1" "$EXT_DESC_FILE"; then
    echo "$LINE1" >> "$EXT_DESC_FILE"
fi
if ! grep -Fxq "$LINE2" "$EXT_DESC_FILE"; then
    echo "$LINE2" >> "$EXT_DESC_FILE"
fi

cd $BUILDROOT_DIR
git reset --hard HEAD
rm configs/custom*
ln -s $PROJECT_DIR/configs/custom_raspberrypi4_64_defconfig $BUILDROOT_DIR/configs/custom_raspberrypi4_64_defconfig
ln -s $PROJECT_DIR/dl $BUILDROOT_DIR/dl
cd $PROJECT_DIR
make -C $BUILDROOT_DIR O=$PROJECT_DIR BR2_EXTERNAL=$PROJECT_DIR BR2_DEFCONFIG=configs/custom_raspberrypi4_64_defconfig defconfig
