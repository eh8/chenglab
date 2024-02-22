{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../modules/common.nix
    ../modules/tailscale.nix
    ../modules/remote-unlock.nix
  ];

  networking.hostName = "sg13chng";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
