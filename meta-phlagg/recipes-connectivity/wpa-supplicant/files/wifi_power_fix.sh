#!/bin/sh
# Prevent the Broadcom Wi-Fi module from sleeping during the boot handshake
if [ "$IFACE" = "wlan0" ]; then
    if command -v iw >/dev/null 2>&1; then
        iw dev wlan0 set power_save off
    elif command -v iwconfig >/dev/null 2>&1; then
        iwconfig wlan0 power off
    fi
fi
