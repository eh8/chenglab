{
  description = "A NixOS flake for a homelab setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
        inherit (pkgs) lib;
        username = "eh8";
      in
      {
        nixosConfigurations.homelab = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            ./hardware-configuration.nix
            ./users/${username}.nix
            ./modules/common-services.nix
            ./modules/jellyfin.nix
            ./modules/nextcloud.nix
            ./modules/nextdns.nix
            ./modules/docker-homebridge.nix
            ({ config, pkgs, ... }: {
              nixpkgs.overlays = [
                (self: super: {
                  # Custom or overridden packages can be added here
                })
              ];

              # ZRAM configuration
              boot.kernelModules = [ "zram" ];
              boot.initrd.availableKernelModules = [ "zram" ];
              boot.initrd.kernelModules = [ "zram" ];
              boot.zramSwap = {
                enable = true;
                size = 4096; # Size in MB
              };

              # SSH configuration
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
            })
          ];
        };
      }
    );
}
