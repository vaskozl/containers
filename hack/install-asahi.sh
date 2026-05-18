#!/bin/sh
# install-asahi.sh -- switch a Fedora-Asahi-Remix-Minimal install over to
# ghcr.io/vaskozl/linux-asahi via bootc.
#
# Prerequisite (from macOS):
#   curl https://alx.sh | sh
# and pick "Fedora Asahi Remix Minimal". That installer creates the
# Apple-managed stub + ESP + /boot (ext4, 1 GiB) + / partitions, flashes
# m1n1 into the stub, and seeds /boot/efi/vendorfw/firmware.tar on the
# ESP. Boot Fedora Minimal, log in as root, fetch this script, run it.
#
# We use `to-existing-root` (NOT `to-disk`): the stub, m1n1, ESP and the
# Fedora-laid grub on /boot must not be touched. `to-disk` would
# repartition and destroy them.
#
# Vendor firmware is handled at first boot by the asahi-firmware dracut
# module from asahi-scripts (baked into our initramfs at image build):
# the pre-udev hook mounts the ESP and cpio-extracts firmware.cpio into
# the initramfs; the cleanup hook copies it into /sysroot. Nothing to do
# from this script.

set -eu

IMG="${IMG:-ghcr.io/vaskozl/linux-asahi:latest}"
SSH_AUTHORIZED_KEYS="${SSH_AUTHORIZED_KEYS:-${HOME}/.ssh/authorized_keys}"

[ "$(id -u)" -eq 0 ]            || { echo "must run as root" >&2; exit 1; }
[ "$(uname -m)" = "aarch64" ]   || { echo "expected aarch64" >&2; exit 1; }
command -v podman >/dev/null    || { echo "podman is required" >&2; exit 1; }

ARGS="--target-imgref $IMG --target-no-signature-verification"
[ -f "$SSH_AUTHORIZED_KEYS" ] && \
  ARGS="$ARGS --root-ssh-authorized-keys $SSH_AUTHORIZED_KEYS"

# Run bootc out of the target image itself: Fedora Asahi Remix Minimal
# is not a bootc host and does not ship `bootc`. This is the documented
# `to-existing-root` pattern from
# https://bootc-dev.github.io/bootc/bootc-install.html.
# shellcheck disable=SC2086
podman run --rm --privileged --pid=host \
  --security-opt label=type:unconfined_t \
  -v /:/target -v /var/lib/containers:/var/lib/containers \
  "$IMG" \
  bootc install to-existing-root --root-path=/target $ARGS

echo "install complete. reboot to land on $IMG."
