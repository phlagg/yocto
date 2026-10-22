#!/bin/bash
set -e

# 1. Clone layers if they don't exist
if [ ! -d "poky" ]; then
    echo "Cloning Yocto layers..."
    git clone --progress -b scarthgap https://yoctoproject.org 2>&1
    cd poky
    git clone --progress -b scarthgap https://yoctoproject.org 2>&1
    git clone --progress -b scarthgap https://openembedded.org 2>&1
    cd ..
fi

# 2. Initialize build environment (Drops execution context into build-rpi folder)
echo "Initializing Bitbake environment..."
source poky/oe-init-build-env build-rpi

git config --global --add safe.directory '*'

# 3. Add configuration if it's a fresh build directory
if ! grep -q 'MACHINE = "raspberrypi3-64"' conf/local.conf; then
    echo "Configuring for Raspberry Pi 3B+..."
    echo 'MACHINE = "raspberrypi3-64"' >> conf/local.conf

    # Corrected layer structural relative paths
    bitbake-layers add-layer "$(pwd)/../poky/meta"
    bitbake-layers add-layer "$(pwd)/../poky/meta-poky"
    bitbake-layers add-layer "$(pwd)/../poky/meta-raspberrypi"
    bitbake-layers add-layer "$(pwd)/../poky/meta-openembedded/meta-oe"
    bitbake-layers add-layer "$(pwd)/../poky/meta-openembedded/meta-python"
    bitbake-layers add-layer "$(pwd)/../poky/meta-openembedded/meta-networking"
    bitbake-layers add-layer "$(pwd)/../meta-phlagg"

    echo 'TMPDIR = "/tmp/yocto-build-scratch"' >> conf/local.conf

    # Hardware resource configuration optimized for i7-6700K (4 Cores / 8 Threads)
    echo 'BB_NUMBER_THREADS = "8"' >> conf/local.conf
    echo 'PARALLEL_MAKE = "-j 6"' >> conf/local.conf
    echo 'DL_DIR = "${TOPDIR}/../yocto-downloads"' >> conf/local.conf
    echo 'SSTATE_DIR = "${TOPDIR}/../yocto-sstate"' >> conf/local.conf

    # Required firmware and license keys for Raspberry Pi 3B+ Wi-Fi
    echo 'LICENSE_FLAGS_ACCEPTED:append = " synaptics-killswitch"' >> conf/local.conf
    echo 'MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS:append = " linux-firmware-rpidistro-bcm43455"' >> conf/local.conf

    # PURE EMBEDDED HEADLESS NETWORKING (With Systemd, No Graphics)
    echo 'DISTRO_FEATURES:append = " systemd usrmerge wifi bluetooth ipv4 ipv6"' >> conf/local.conf
    echo 'DISTRO_FEATURES:remove = " wayland vulkan x11 amdhsa opencl directfb sysvinit 3g"' >> conf/local.conf

    # Target systemd as the init manager for Scarthgap
    echo 'INIT_MANAGER = "systemd"' >> conf/local.conf
    echo 'DISTRO_FEATURES_BACKFILL_CONSIDERED += "sysvinit"' >> conf/local.conf
    # Forces the wpa_supplicant service instance to automatically hook onto wlan0 at boot time
    echo 'SYSTEMD_AUTO_ENABLE:pn-wpa-supplicant = "enable"' >> conf/local.conf
    echo 'SYSTEMD_SERVICE:pn-wpa-supplicant:append = " wpa_supplicant@wlan0.service"' >> conf/local.conf

fi

echo "=========================================================="
echo " Environment ready! Run your custom image build: "
echo "   bitbake phlagg-image"
echo "=========================================================="
/bin/bash
