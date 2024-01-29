{ config, pkgs, lib, ... }:

{
  # Common services configuration for the homelab

  # Enable ZRAM
  boot.zramSwap = {
    enable = true;
    size = config.lib.mkDefault 4096; # Size in MB, can be overridden if needed
  };

  # SSH configuration with authorized keys
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    authorizedKeysFiles = [ "/etc/nixos/secrets/ssh-authorized-keys" ];
  };

  # LUKS encrypted drive configuration
  boot.initrd.luks.devices = {
    encrypted = {
      device = "/dev/disk/by-uuid/your-uuid-here"; # Replace with the actual UUID of the LUKS device
      preLVM = true;
      keyFile = "/etc/nixos/secrets/luks-keyfile";
    };
  };

  # Define any additional common services or system-wide settings here
}
