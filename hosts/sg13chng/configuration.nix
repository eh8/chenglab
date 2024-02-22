{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../modules/core/common.nix
    ../modules/core/home.nix
    ../modules/core/remote-unlock.nix
    ../modules/tailscale.nix
  ];

  networking.hostName = "sg13chng";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
