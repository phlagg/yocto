#!/usr/bin/env python3
import asyncio
import os
import pty

from bleak import BleakPeripheral  # Standard lightweight BLE framework

# Nordic UART Service Custom UUIDs
NUS_UUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
RX_UUID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"  # Write without response
TX_UUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"  # Notify


class BleUartBridge:
    def __init__(self):
        # 1. Create a POSIX Pseudo-Terminal (PTY) pair
        self.master_fd, self.slave_fd = pty.openpty()
        self.slave_name = os.ttyname(self.slave_fd)

        # 2. Create a stable symlink for your main C application to target
        self.symlink_path = "/dev/ble_serial"
        if os.path.exists(self.symlink_path):
            os.remove(self.symlink_path)
        os.symlink(self.slave_name, self.symlink_path)
        print(f"Virtual COM Port created at: {self.symlink_path} -> {self.slave_name}")

    def rx_callback(self, handle, data):
        """Triggered when the mobile app writes data to the Pi over BLE"""
        # Forward incoming BLE data directly into the Virtual Serial Port
        os.write(self.master_fd, data)

    async def run(self):
        # 3. Configure the BLE peripheral
        peripheral = BleakPeripheral()
        # (In production, map out the GATT database using BlueZ DBus)
        # For brevity, this abstracts standard initialization of the NUS profile

        loop = asyncio.get_running_loop()
        print("BLE UART Daemon started. Listening for connections...")

        while True:
            # 4. Asynchronously check if your C application has written to the TTY
            # If it did, read the bytes and emit them as a BLE notification (TX)
            try:
                data = await loop.run_in_executor(None, os.read, self.master_fd, 1024)
                if data:
                    # In a fully realized implementation:
                    # await peripheral.send_notification(TX_UUID, data)
                    print(f"Forwarded from TTY to BLE: {data}")
            except Exception:
                await asyncio.sleep(0.1)


if __name__ == "__main__":
    bridge = BleUartBridge()
    try:
        asyncio.run(bridge.run())
    except KeyboardInterrupt:
        if os.path.exists(bridge.symlink_path):
            os.remove(bridge.symlink_path)
