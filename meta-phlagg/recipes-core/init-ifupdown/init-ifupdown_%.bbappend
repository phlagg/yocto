FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

do_install:append() {
    # Convert eth0 from blocking 'auto' to non-blocking 'allow-hotplug'
    sed -i 's/auto eth0/allow-hotplug eth0/g' ${D}${sysconfdir}/network/interfaces

    # Append our automatic Wi-Fi rules directly to the system interfaces file
    cat << 'EOF' >> ${D}${sysconfdir}/network/interfaces

# Phlagg Automated Wireless DHCP Interface Configuration
auto wlan0
iface wlan0 inet dhcp
    wpa-conf etc/wpa_supplicant/wpa_supplicant.conf
    udhcpc_opts -b -T 3 -A 2
EOF
}
