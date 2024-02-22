#!/usr/bin/env bash
# https://mhu.dev/posts/2024-01-06-nixos-on-hetzner/
set -e -u -o pipefail -x

lsblk

# Undo any previous changes.
# This allows me to re-run the script many times over
set +e
umount -R /mnt
cryptsetup close cryptroot
vgchange -an
set -e

# Partitioning
parted /dev/nvme0n1 -s mklabel gpt
parted /dev/nvme0n1 -s mkpart ESP fat32 1MiB 512MiB
parted /dev/nvme0n1 -s set 1 esp on
parted /dev/nvme0n1 -s mkpart primary ext4 512MiB 100%

# Set up encryption
# At this point, the script will ask for the LUKS passphrase _twice_
cryptsetup -q -v luksFormat /dev/nvme0n1p2
cryptsetup -q -v open /dev/nvme0n1p2 cryptroot

# Create filesystems
# We'll make heavy use of labels to identify the FS' later
mkfs.fat  -F32 -n boot /dev/nvme0n1p1
mkfs.ext4 -F -L nix -m 0 /dev/mapper/cryptroot

# Mount filesystems
mount -t tmpfs none /mnt

# Create & mount additional mount points
mkdir -pv /mnt/{boot,nix,etc/{nixos,ssh},var/{lib,log},srv}

mount /dev/disk/by-label/boot  /mnt/boot
mount /dev/disk/by-label/nix   /mnt/nix

# Create & mount directories for persistence
mkdir -pv /mnt/nix/{secret/initrd,persist/{etc/{nixos,ssh},var/{lib,log},srv}}
chmod 0700 /mnt/nix/secret

mount -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
mount -o bind /mnt/nix/persist/var/log   /mnt/var/log

# Generated initrd SSH host key
ssh-keygen -t ed25519 -N "" -C "" -f /mnt/nix/secret/initrd/ssh_host_ed25519_key