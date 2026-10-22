SUMMARY = "Phlagg Custom Raspberry Pi 3B+ OS Image with Peripherals"
LICENSE = "MIT"

# 1. Inherit core system baseline
inherit core-image

# 2. Add System Features (Handles OpenSSH and debug access cleanly)
IMAGE_FEATURES:append = " ssh-server-openssh allow-empty-password empty-root-password allow-root-login"

# 3. Core peripheral drivers, custom services, and wireless utilities
IMAGE_INSTALL:append = " \
    wpa-supplicant \
    iw \
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
    packagegroup-product-dev \
    packagegroup-product-apps \
"
# 4. Explicit hardware enablement for Raspberry Pi peripherals
ENABLE_SPI_BUS = "1"
