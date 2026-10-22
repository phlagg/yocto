
Alternative 1: RAUC Application Bundles (Lowest Overhead)

If you are already using an update manager like RAUC or SWUpdate for your A/B system updates, you can use them to update applications independently.
• The Setup: You create a separate, writeable partition (e.g., /apps) alongside your read-only A/B OS partitions. Your application binaries and configurations live there.
• How it works: RAUC allows you to define custom slots and "sub-bundles." Instead of an entire OS image, you create an update bundle containing just your compiled application binaries.
• Security without containers: RAUC signs the application bundle using the exact same asymmetric cryptography infrastructure (x.509 certificates) used for the OS. The RAUC daemon on the device verifies the signature before writing the files to the /apps directory.
• Overhead: Zero at runtime. Your app runs as a native systemd service with no abstraction layer.

Alternative 2: Systemd System Extensions (systemd-sysext)

If your Yocto image uses systemd, this is a built-in feature designed specifically to solve the "container bloat" problem on secure, read-only operating systems.
• The Setup: Your application files are compiled into a tiny, read-only filesystem image (like a SquashFS image file) stored on a writable data partition.
• How it works: When the device boots, systemd-sysext dynamically overlays this image onto the /usr directory of your read-only rootfs. To the OS, the application looks like it was baked into the main image.
• Security without containers: You protect the image using dm-verity. The kernel validates a cryptographic hash tree embedded in the image file against a public key built into the boot chain. If a single byte of your app binary is tampered with on disk, the kernel blocks the read operation.
• Overhead: Near zero. It relies on native kernel filesystem mounting. There is no background daemon or runtime engine using up RAM.
