do_install:append() {
    # Safely append the respawn hook to the official system configuration file
    # echo "" >> ${D}${sysconfdir}/inittab
    # echo "# Run phlagg's interactive TUI directly on the physical screen without blocking boot scripts" >> ${D}${sysconfdir}/inittab
    # echo "tty1::respawn:/usr/bin/my-app" >> ${D}${sysconfdir}/inittab
}
