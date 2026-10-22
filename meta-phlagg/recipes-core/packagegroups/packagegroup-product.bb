SUMMARY = "Product Core Application Package Groups"
DESCRIPTION = "Groups all custom services, GUI, and developer tools for the product."
LICENSE = "MIT"

# The packagegroup class automatically handles creating the packages
# and setting up basic runtime dependencies.
inherit packagegroup

# Define the separate runtime packages this recipe will output
PACKAGES = "\
    ${PN} \
    packagegroup-product-apps \
    packagegroup-product-dev \
"

# Bind the core apps to the base packagegroup target
RDEPENDS:${PN} = "\
    packagegroup-product-apps \
"

# =====================================================================
# 1. CORE PRODUCTION APPLICATIONS & SERVICES
# =====================================================================
# These will be automatically included in your final production image.
RDEPENDS:packagegroup-product-apps = "\
    api-manager \
    ble-uart-service \
    telemetryd \
    spi-example \
"
# wifi-manager
# storage-manager
# ethernet-manager
# gui-manager

# =====================================================================
# 2. MAINTENANCE / DEVELOPMENT ONLY TOOLS
# =====================================================================
# These are kept strictly isolated so they never leak into a production image
# unless you explicitly ask for them.
RDEPENDS:packagegroup-product-dev = "\
    strace \
    gdbserver \
    htop \
    util-linux-lsblk \
"
