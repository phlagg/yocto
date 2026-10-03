FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Keep your configuration file and add the power fix script
SRC_URI += "file://wpa_supplicant.conf \
            file://wifi_power_fix.sh"

do_install:append() {
    # This safely overwrites the default empty file provided by the base recipe
    install -m 0600 ${WORKDIR}/wpa_supplicant.conf ${D}${sysconfdir}/wpa_supplicant.conf

    # AUTOMATED FIX: Deploy the hardware power override hook
    install -d ${D}${sysconfdir}/network/if-pre-up.d
    install -m 0755 ${WORKDIR}/wifi_power_fix.sh ${D}${sysconfdir}/network/if-pre-up.d/wifi_power_fix
}
