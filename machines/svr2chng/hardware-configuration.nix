{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      # `readlink /sys/class/net/enp0s31f6/device/driver` indicates "e1000e" is the ethernet driver for this device
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "e1000e"];
      luks.devices."cryptroot".device = "/dev/nvme0n1p2";
      luks.devices."cryptroot".allowDiscards = true;
      luks.devices."fun".device = "/dev/sda1";
      luks.reusePassphrases = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=2G" "mode=0755"];
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = ["umask=0077"];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix";
      fsType = "ext4";
    };
    "/fun" = {
      device = "/dev/disk/by-label/fun";
      fsType = "ext4";
    };
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
