SUMMARY = "Phlagg Custom Raspberry Pi 3B+ OS Image with Peripherals"
LICENSE = "MIT"

# 1. Inherit core system baseline
#inherit core-image

# Pull in the exact, bare-minimum recipe blueprint directly
require recipes-core/images/core-image-minimal.bb

# 2. Add baseline features (CHANGED: Dropped openssh to eliminate heavy package-management deps)
IMAGE_FEATURES += "ssh-server-dropbear"
EXTRA_IMAGE_FEATURES = "allow-empty-password empty-root-password allow-root-login"

# 3. Core peripheral drivers and wireless packages
IMAGE_INSTALL:append = " \
    wpa-supplicant \
    dhcpcd \
    net-tools \
    kernel-modules \
    wireless-regdb-static \
    bluez5 \
    bluez5-noinst-tools \
    pi-bluetooth \
    libgpiod \
    libgpiod-tools \
    i2c-tools \
    spitools \
    telemetryd \
"
