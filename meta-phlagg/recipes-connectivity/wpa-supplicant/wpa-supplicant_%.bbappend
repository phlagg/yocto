FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://wpa_supplicant-nl80211-wlan0.conf"

do_install:append() {
    # 1. Install the targeted configurations directory
    install -d ${D}${sysconfdir}/wpa_supplicant
    install -m 0600 ${WORKDIR}/wpa_supplicant-nl80211-wlan0.conf ${D}${sysconfdir}/wpa_supplicant/wpa_supplicant-nl80211-wlan0.conf

    # 2. Deploy systemd-networkd DHCP network rules for the wlan0 interface
    install -d ${D}${sysconfdir}/systemd/network
    cat << 'EOF' > ${D}${sysconfdir}/systemd/network/25-wlan0.network
[Match]
Name=wlan0

[Network]
DHCP=yes
EOF

    # 3. Enable the automated systemd interface service unit link
    install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants
    ln -s ${systemd_unitdir}/system/wpa_supplicant@.service \
          ${D}${sysconfdir}/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service
}
