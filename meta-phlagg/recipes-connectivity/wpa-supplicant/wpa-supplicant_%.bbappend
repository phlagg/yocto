FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Keep your configuration file and add the power fix script
SRC_URI += "file://wpa_supplicant.conf \
            file://wifi_power_fix.sh"

do_install:append() {
    # Create the directory just in case it doesn't exist
    install -d ${D}${sysconfdir}/wpa_supplicant

    # Install inside the expected subdirectory
    install -m 0600 ${WORKDIR}/wpa_supplicant.conf ${D}${sysconfdir}/wpa_supplicant/wpa_supplicant.conf

    # FIX: Deploy the power override hook to if-up.d (runs AFTER carrier is acquired)
    install -d ${D}${sysconfdir}/network/if-up.d
    install -m 0755 ${WORKDIR}/wifi_power_fix.sh ${D}${sysconfdir}/network/if-up.d/wifi_power_fix
}
