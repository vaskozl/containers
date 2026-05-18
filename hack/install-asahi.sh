#!/bin/sh
# install-asahi.sh -- lay down ghcr.io/vaskozl/linux-asahi onto an Apple
# Silicon Mac that has already been prepared by the upstream Asahi
# installer (arvanta's Alpine variant: `curl https://arvanta.net/asahi/aai.sh | sh`).
#
# alx.sh upstream does NOT offer an Alpine option -- its installer_data.json
# only lists Fedora Asahi Remix variants. arvanta.net/asahi/aai.sh is a
# wrapper around the same installer with an installer_data.json that ships
# Alpine ARM. See https://arvanta.net/alpine/install-alpine-m1/.
#
# Modelled on Alpine's install.m1 from that guide: explicit partition
# discovery, ESP mount + firmware-tar verification, image bootstrap,
# boot/firmware/SSH wiring, MOTD. The difference is we bootc-install an
# OCI image instead of `apk --root --initdb add` -- our root is an OCI
# image, not a package set.
#
# Repartitioning the internal SSD ourselves is NOT safe: Apple Silicon
# boots iBoot -> m1n1 -> Linux, and m1n1 + the vendor firmware are flashed
# onto Apple-managed GPT entries that only `asahi-installer` knows how to
# create. `bootc install to-disk` would wipe those. Use the upstream
# installer for stage 1, this script for stage 2.

set -eu

IMG="${IMG:-ghcr.io/vaskozl/linux-asahi:latest}"
ESP_MOUNT="${ESP_MOUNT:-/boot/efi}"
SSH_AUTHORIZED_KEYS="${SSH_AUTHORIZED_KEYS:-${HOME}/.ssh/authorized_keys}"

log() { printf '==> %s\n' "$*" >&2; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

# --- preflight ----------------------------------------------------------------

[ "$(id -u)" -eq 0 ] || die "must run as root"

arch=$(uname -m)
[ "$arch" = "aarch64" ] || die "expected aarch64, got $arch (run inside the stub Alpine on M1/M2)"

command -v bootc   >/dev/null 2>&1 || die "bootc is missing from the stub OS; install with: apk add bootc"
command -v podman  >/dev/null 2>&1 || die "podman is missing from the stub OS; install with: apk add podman"
command -v findmnt >/dev/null 2>&1 || die "findmnt is missing; install with: apk add util-linux"

# --- discover partitions ------------------------------------------------------
#
# `asahi-installer` lays out (per Apple-style GPT) on the internal SSD:
#   <prefix>s1  EFI         -> contains m1n1 stage 2, /vendorfw/firmware.tar
#   <prefix>s2  Linux root  -> mounted at / in the stub Alpine
# Both must already be present and mounted; we never recreate them.

ROOT_SRC=$(findmnt -no SOURCE /) || die "cannot resolve / source partition"
log "root partition:  $ROOT_SRC"

if ! findmnt -no SOURCE "$ESP_MOUNT" >/dev/null 2>&1; then
  log "ESP not mounted at $ESP_MOUNT, attempting to locate and mount it"
  esp_part=$(blkid -t TYPE=vfat -o device | head -n1) \
    || die "no vfat partition found -- asahi-installer did not run, or its ESP is missing"
  mkdir -p "$ESP_MOUNT"
  mount -t vfat -o rw "$esp_part" "$ESP_MOUNT"
fi
ESP_SRC=$(findmnt -no SOURCE "$ESP_MOUNT")
log "ESP partition:   $ESP_SRC (at $ESP_MOUNT)"

[ -d "$ESP_MOUNT/m1n1" ] || [ -f "$ESP_MOUNT/m1n1/boot.bin" ] || \
  log "warning: no m1n1 stage-2 on ESP; verify asahi-installer completed before continuing"

if [ ! -f "$ESP_MOUNT/vendorfw/firmware.tar" ]; then
  log "warning: $ESP_MOUNT/vendorfw/firmware.tar missing"
  log "         WiFi/Bluetooth firmware extraction on first boot will fail"
  log "         (asahi-fwextract.service expects this file)"
fi

# --- pull image ---------------------------------------------------------------

log "pulling $IMG"
podman pull "$IMG"

# --- bootc install ------------------------------------------------------------
#
# `to-existing-root` overlays the OCI image onto the current /, switches the
# kernel/initramfs that grub (chainloaded from m1n1) boots, and rewrites
# /ostree + /boot. It preserves the ESP, m1n1 partitions, and the GPT.
#
# `--target-no-signature-verification` because the image is published to
# ghcr without cosign signatures (matches pinewall-config's bootc usage).
# Drop once we start signing.

INSTALL_ARGS="--target-imgref $IMG --target-no-signature-verification"
INSTALL_ARGS="$INSTALL_ARGS --karg=console=tty0 --karg=earlycon"

if [ -f "$SSH_AUTHORIZED_KEYS" ]; then
  log "seeding root SSH authorized_keys from $SSH_AUTHORIZED_KEYS"
  INSTALL_ARGS="$INSTALL_ARGS --root-ssh-authorized-keys $SSH_AUTHORIZED_KEYS"
fi

log "running: bootc install to-existing-root $INSTALL_ARGS"
# shellcheck disable=SC2086
bootc install to-existing-root $INSTALL_ARGS

# --- post-install -------------------------------------------------------------

log "bootc status (post-install):"
bootc status || true

deployed_etc=$(find /ostree/deploy -maxdepth 4 -type d -name etc 2>/dev/null | head -n1 || true)
if [ -n "$deployed_etc" ]; then
  cat > "$deployed_etc/motd" <<'MOTD'
Booted from ghcr.io/vaskozl/linux-asahi (bootc).

First boot extracts /boot/vendorfw/firmware.tar via asahi-fwextract.service;
WiFi/Bluetooth come up after that runs. Check with:
  systemctl status asahi-fwextract.service
  bootc status
MOTD
fi

cat <<EOF

================================================================
install complete.

Next:
  1. reboot
  2. m1n1 -> u-boot -> grub -> linux-asahi will boot the deployed image
  3. on first boot, asahi-fwextract.service extracts vendor firmware
     from $ESP_MOUNT/vendorfw/firmware.tar -- WiFi/BT come up after
  4. \`bootc status\` should report $IMG as booted

To roll forward later:
  bootc upgrade --apply
================================================================
EOF
