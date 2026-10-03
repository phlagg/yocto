FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Append our automatic Wi-Fi rules directly to the system interfaces file
do_install:append() {
    cat << 'EOF' >> ${D}${sysconfdir}/network/interfaces

# Phlagg Automated Wireless DHCP Interface Configuration
auto wlan0
iface wlan0 inet dhcp
    wpa-conf /etc/wpa_supplicant.conf
EOF
}
