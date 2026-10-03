SUMMARY = "Simple custom test application with Wi-Fi Init"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://main.c \
"

S = "${WORKDIR}"

# Force this application to wait for the network system packages to be ready first
RDEPENDS:${PN} += "wpa-supplicant"

do_compile() {
    ${CC} ${CFLAGS} ${LDFLAGS} main.c -o my-app
}

do_install() {
    # Install the compiled binary executable to /usr/bin/
    install -d ${D}${bindir}
    install -m 0755 my-app ${D}${bindir}/
}
