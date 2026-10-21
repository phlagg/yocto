#!/bin/bash
set -e

# 1. Target configurations
IMAGE="./pi-images/phlagg-image-raspberrypi3-64.rootfs.wic.bz2"
BMAP="./pi-images/phlagg-image-raspberrypi3-64.rootfs.wic.bmap"

# 2. Automatically find your SD card block device
echo "Current available disk storage blocks:"
lsblk
echo "--------------------------------------------------"
read -p "Enter the target SD card device path (e.g., /dev/sdb): " DEST_DEV

# 3. Validation safety check
if [ ! -b "$DEST_DEV" ]; then
    DEST_DEV="/dev/sdb"
    # echo "❌ Error: $DEST_DEV is not a valid block device system node."
    # exit 1
fi

# 4. Install bmaptool on Arch if missing
if ! command -v bmaptool &> /dev/null; then
    echo "Installing bmap-tools on host..."
    sudo pacman -S --noconfirm bmap-tools
fi

# 5. Unmount auto-mounted partitions to prevent file system corruption
echo "Unmounting existing partitions on $DEST_DEV..."
sudo umount "${DEST_DEV}"* 2>/dev/null || true

# 6. Execute high-speed flashing sequence
echo "Flashing image to $DEST_DEV using bmaptool..."
sudo bmaptool copy --bmap "$BMAP" "$IMAGE" "$DEST_DEV"

echo "=========================================================="
echo " Done! Your Raspberry Pi SD card is ready to boot. "
echo "=========================================================="
