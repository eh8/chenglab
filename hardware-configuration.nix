# hardware-configuration.nix

{ config, pkgs, ... }:

{
  # Specify the file systems, for example:
  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  # If you have a swap partition, you can specify it like this:
  # swapDevices =
  #   [ { device = "/dev/disk/by-label/swap"; }
  #   ];

  # For setting up ZRAM, additional configuration is done in the flake.nix
  # as shown in the snippet provided.

  # Configure the network interface, replace `enp3s0` with your actual network interface name
  networking.interfaces.enp3s0.useDHCP = true;

  # Set up the hostname, this is also done in configuration.nix, so it's not strictly necessary here
  # networking.hostName = "homelab"; # Define your hostname

  # Hardware-specific configuration for enabling hardware features
  # hardware.opengl.enable = true;
  # hardware.pulseaudio.enable = true;

  # Define any additional kernel modules or hardware-specific settings here
  # boot.kernelModules = [ "kvm-intel" ];
  # boot.extraModulePackages = [ pkgs.linuxPackages.nvidia_x11 ];

  # Note: The actual hardware configuration will depend on the specific hardware in your homelab.
  # You should run `nixos-generate-config` on the target machine to get a proper hardware-configuration.nix
  # and then adjust it according to your needs.
}
