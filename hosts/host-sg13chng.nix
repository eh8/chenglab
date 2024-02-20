{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../hardware/hardware-sg13chng.nix
    ../modules/common.nix
    ../modules/tailscale.nix
  ];

  networking.hostName = "sg13chng";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
