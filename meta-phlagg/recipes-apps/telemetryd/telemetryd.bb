SUMMARY = "Telemetry Daemon Application"
LICENSE = "CLOSED"

inherit go-mod systemd

FILESEXTRAPATHS:prepend := "${THISDIR}:"

SRC_URI = " \
    file://go.mod;subdir=src/telemetryd \
    file://go.sum;subdir=src/telemetryd \
    file://cmd/;subdir=src/telemetryd \
    file://internal/;subdir=src/telemetryd \
    file://telemetryd.init"

S = "${WORKDIR}"

GO_IMPORT = "telemetryd"

# CLEAN FIX: Point directly to the specific command directory.
# Yocto will automatically name the final binary "telemetryd".
GO_INSTALL = "${GO_IMPORT}/cmd/telemetryd"
GO_LINKSHARED = ""

inherit update-rc.d

INITSCRIPT_NAME = "telemetryd"
INITSCRIPT_PARAMS = "defaults 99"

do_install:append() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 \
        ${WORKDIR}/telemetryd.init \
        ${D}${sysconfdir}/init.d/telemetryd
}
