#!/usr/bin/env bash

set -e -u -o pipefail

if [ "$(uname)" == "Darwin" ]; then
  # Display warning and wait for confirmation to proceed
  echo "macOS detected"
  echo -e "\n\033[1;31m**Warning:** This script will prepare system for nix-darwin installation.\033[0m"
  read -n 1 -s -r -p "Press any key to continue or Ctrl+C to abort..."

  # inspo: https://forums.developer.apple.com/forums/thread/698954
  echo -e "\n\033[1mInstalling Xcode...\033[0m"
  if [[ -e /Library/Developer/CommandLineTools/usr/bin/git ]]; then
    echo -e "\033[32mXcode already installed.\033[0m"
  else
    # This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
    softwareupdate -i "$PROD" --verbose
    echo -e "\033[32mXcode installed successfully.\033[0m"
  fi

  echo -e "\n\033[1mInstalling Rosetta...\033[0m"
  softwareupdate --install-rosetta --agree-to-license
  echo -e "\033[32mRosetta installed successfully.\033[0m"

  echo -e "\n\033[1mInstalling Nix...\033[0m"
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

  # Completed
  echo -e "\n\033[1;32mAll steps completed successfully. nix-darwin is now ready to be installed.\033[0m\n"
  echo -e "To install nix-darwin configuration, run the following commands:\n"
  echo -e "\033[1m. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh\033[0m\n"
  echo -e "\033[1mnix run nix-darwin -- switch --flake github:eh8/chenglab#mac1chng\033[0m\n"
  echo -e "Remember to add the new host public key to sops-nix!"
elif [ "$(uname)" == "Linux" ]; then
  # Define disk
  DISK="/dev/nvme0n1"
  DISK_BOOT_PARTITION="/dev/nvme0n1p1"
  DISK_NIX_PARTITION="/dev/nvme0n1p2"

  # Display warning and wait for confirmation to proceed
  echo "Linux detected"
  echo -e "\n\033[1;31m**Warning:** This script is irreversible and will prepare system for NixOS installation.\033[0m"
  read -n 1 -s -r -p "Press any key to continue or Ctrl+C to abort..."

  # Clear screen before showing disk layout
  clear

  # Display disk layout
  echo -e "\n\033[1mDisk Layout:\033[0m"
  lsblk
  echo ""

  # Undo any previous changes if applicable
  echo -e "\n\033[1mUndoing any previous changes...\033[0m"
  set +e
  umount -R /mnt
  cryptsetup close cryptroot
  set -e
  echo -e "\033[32mPrevious changes undone.\033[0m"

  # Partitioning disk
  echo -e "\n\033[1mPartitioning disk...\033[0m"
  parted $DISK -- mklabel gpt
  parted $DISK -- mkpart ESP fat32 1MiB 512MiB
  parted $DISK -- set 1 boot on
  parted $DISK -- mkpart Nix 512MiB 100%
  echo -e "\033[32mDisk partitioned successfully.\033[0m"

  # Setting up encryption
  echo -e "\n\033[1mSetting up encryption...\033[0m"
  cryptsetup -q -v luksFormat $DISK_NIX_PARTITION
  cryptsetup -q -v open $DISK_NIX_PARTITION cryptroot
  echo -e "\033[32mEncryption setup completed.\033[0m"

  # Creating filesystems
  echo -e "\n\033[1mCreating filesystems...\033[0m"
  mkfs.fat -F32 -n boot $DISK_BOOT_PARTITION
  mkfs.ext4 -F -L nix -m 0 /dev/mapper/cryptroot
  # Let mkfs catch its breath
  sleep 2
  echo -e "\033[32mFilesystems created successfully.\033[0m"

  # Mounting filesystems
  echo -e "\n\033[1mMounting filesystems...\033[0m"
  mount -t tmpfs none /mnt
  mkdir -pv /mnt/{boot,nix,etc/ssh,var/{lib,log}}
  mount /dev/disk/by-label/boot /mnt/boot
  mount /dev/disk/by-label/nix /mnt/nix
  mkdir -pv /mnt/nix/{secret/initrd,persist/{etc/ssh,var/{lib,log}}}
  chmod 0700 /mnt/nix/secret
  mount -o bind /mnt/nix/persist/var/log /mnt/var/log
  echo -e "\033[32mFilesystems mounted successfully.\033[0m"

  # Generating initrd SSH host key
  echo -e "\n\033[1mGenerating initrd SSH host key...\033[0m"
  ssh-keygen -t ed25519 -N "" -C "" -f /mnt/nix/secret/initrd/ssh_host_ed25519_key
  echo -e "\033[32mSSH host key generated successfully.\033[0m"

  # Creating public age key for sops-nix
  echo -e "\n\033[1mConverting initrd public SSH host key into public age key for sops-nix...\033[0m"
  sudo nix-shell --extra-experimental-features flakes -p ssh-to-age --run 'cat /mnt/nix/secret/initrd/ssh_host_ed25519_key.pub | ssh-to-age'
  echo -e "\033[32mAge public key generated successfully.\033[0m"

  # Completed
  echo -e "\n\033[1;32mAll steps completed successfully. NixOS is now ready to be installed.\033[0m\n"
  echo -e "Remember to commit and push the new server's public host key to sops-nix/update all sops encrypted files before installing!"
  echo -e "To install NixOS configuration for hostname, run the following command:\n"
  echo -e "\033[1msudo nixos-install --no-root-passwd --root /mnt --flake github:eh8/chenglab#hostname\033[0m\n"
fi
