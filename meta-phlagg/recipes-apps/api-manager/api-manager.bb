SUMMARY = "Production API Manager"
LICENSE = "CLOSED"

## 1. Point to your remote SVN repository using the svn fetcher.
## Note the explicit 'protocol=https' and the mandatory ';module=' parameter.
#SRC_URI = "svn://://yourcompany.com \
#           file://api-manager.service"
#
## 2. Pin to a strict, numeric SVN revision number for deterministic production builds
#SRCREV = "1402"
#
## 3. SVN checks out the code into ${WORKDIR}/${module}, so point S directly to it
#S = "${WORKDIR}/api-manager-src"



# 1. Provide the complete path: ://github.com<your-username>/<your-repo-name>.git
#SRC_URI = "git://git@github.com/phlagg/api-manager.git;branch=main;protocol=https \
#           file://api-manager.service"

SRC_URI = "git:///workdir/local-repos/api-manager;branch=main;protocol=file \
           file://api-manager.service"

# 2. Pin to a strict commit hash (or Git tag) for deterministic builds
SRCREV = "${AUTOREV}"
PV = "1.0+git${SRCPV}"

# 3. Yocto clones git into ${WORKDIR}/git, so we tell the recipe to look there
S = "${WORKDIR}/git"

inherit cmake systemd

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} = "api-manager.service"

# This single function runs AFTER CMake's built-in installation finishes.
# CMake handles placing the binary into /usr/bin automatically, so we
# only need to manually install the external systemd service file here.
do_install:append() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/api-manager.service ${D}${systemd_system_unitdir}/
}
