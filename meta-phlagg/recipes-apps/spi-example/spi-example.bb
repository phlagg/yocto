SUMMARY = "SPI application with production security configurations"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://spi_example.c \
    file://99-spi.rules \
"

S = "${WORKDIR}"

# Inherit the useradd class to safely create users and groups during the image build
inherit useradd

# Define the user/group creation parameters
USERADD_PACKAGES = "${PN}"
GROUPADD_PARAM:${PN} = "-r spiaccess"
USERADD_PARAM:${PN} = "-r -g spiaccess -d /var/lib/myapp -m -s /bin/false myappuser"

do_compile() {
    ${CC} ${CFLAGS} ${LDFLAGS} spi_example.c -o spi_example
}

do_install() {
    # 1. Install the binary executable
    install -d ${D}${bindir}
    install -m 0755 spi_example ${D}${bindir}/

    # 2. Install the udev rule into the standard system directory
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/99-spi.rules ${D}${sysconfdir}/udev/rules.d/
}

# Ensure the files are tracked by the package
FILES:${PN} += " \
    ${bindir}/spi_example \
    ${sysconfdir}/udev/rules.d/99-spi.rules \
"
