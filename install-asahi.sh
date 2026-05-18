#!/bin/sh
set -eux
IMG="${IMG:-ghcr.io/vaskozl/linux-asahi:latest}"

podman pull "$IMG"

# `to-existing-root`, not `to-disk`: the macOS-side installer already
# partitioned the disk, flashed m1n1, and placed firmware on the ESP.
# `to-disk` would repartition and destroy those.
bootc install to-existing-root \
  --target-imgref "$IMG" \
  --root-ssh-authorized-keys "${HOME}/.ssh/authorized_keys"

# First-boot vendor firmware extraction from the ESP into /lib/firmware
# so WiFi/Bluetooth come up after reboot.
if [ -f /boot/vendorfw/firmware.tar ]; then
  tar xvf /boot/vendorfw/firmware.tar -C /lib/firmware
fi
