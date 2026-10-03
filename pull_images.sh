#!/bin/bash
set -e

# 🛠️ EDIT THESE CONFIGURATIONS:
VM_USER="phlagg"                  # Your username on the Arch VM
VM_IP="192.168.1.50"               # Replace with your Arch VM's actual IP address
REMOTE_PATH="~/path/to/your/workspace/pi-images" # Path to your workspace folder on Arch
LOCAL_DEST="./pi-images"           # Where you want the files saved on your main machine

echo "Connecting to Arch VM at $VM_IP..."
mkdir -p "$LOCAL_DEST"

# Pull the compressed image and the bmap tracking file
scp "$VM_USER@$VM_IP:$REMOTE_PATH/core-image-minimal-raspberrypi3-64.rootfs.wic.*" "$LOCAL_DEST/"

echo "=========================================================="
echo " Copy Complete! Files are ready in $LOCAL_DEST"
echo "=========================================================="
ls -lh "$LOCAL_DEST"
