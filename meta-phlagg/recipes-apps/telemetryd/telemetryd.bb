SUMMARY = "Telemetry Daemon Application"
LICENSE = "CLOSED"

inherit go-mod systemd

FILESEXTRAPATHS:prepend := "${THISDIR}:"

SRC_URI = " \
    file://go.mod;subdir=src/telemetryd \
    file://go.sum;subdir=src/telemetryd \
    file://cmd/;subdir=src/telemetryd \
    file://internal/;subdir=src/telemetryd \
    file://telemetryd.service \
"

S = "${WORKDIR}"

GO_IMPORT = "telemetryd"

# CLEAN FIX: Point directly to the specific command directory.
# Yocto will automatically name the final binary "telemetryd".
GO_INSTALL = "${GO_IMPORT}/cmd/telemetryd"
GO_LINKSHARED = ""

SYSTEMD_SERVICE:${PN} = "telemetryd.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install:append() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/telemetryd.service ${D}${systemd_system_unitdir}/
}

FILES:${PN} += "${systemd_system_unitdir}/telemetryd.service"
