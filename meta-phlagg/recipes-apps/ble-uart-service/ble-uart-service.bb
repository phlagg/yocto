SUMMARY = "Unified BLE Virtual COM Port Service and Diagnostic Tool"
DESCRIPTION = "Includes both the background BLE-to-TTY daemon and a native C diagnostic utility"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# Pull in all three source files from the files/ directory
SRC_URI = " \
    file://ble_uart_daemon.py \
    file://99-ble-uart.rules \
    file://ble_serial_test.c \
"

S = "${WORKDIR}"

# Runtime dependencies required specifically by the Python daemon component
RDEPENDS:${PN} += " \
    python3-core \
    python3-asyncio \
    python3-io \
    python3-bleak \
    bluez5 \
"

# Task 1: Compile the C diagnostic application using Yocto's cross-compiler flags
do_compile() {
    ${CC} ${CFLAGS} ${LDFLAGS} ble_serial_test.c -o ble_serial_test
}

# Task 2: Install everything into their production directories on the rootfs
do_install() {
    # 1. Install the native C diagnostic binary into standard user-space binaries (/usr/bin)
    install -d ${D}${bindir}
    install -m 0755 ble_serial_test ${D}${bindir}/

    # 2. Install the background daemon script into system binaries (/usr/libexec)
    install -d ${D}${libexecdir}
    install -m 0755 ${WORKDIR}/ble_uart_daemon.py ${D}${libexecdir}/ble_uart_daemon

    # 3. Install the production permission rules for the virtual serial nodes
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/99-ble-uart.rules ${D}${sysconfdir}/udev/rules.d/
}

# Map all files out securely to track them in the final image package
FILES:${PN} += " \
    ${bindir}/ble_serial_test \
    ${libexecdir}/ble_uart_daemon \
    ${sysconfdir}/udev/rules.d/99-ble-uart.rules \
"
