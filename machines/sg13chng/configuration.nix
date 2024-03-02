{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/common.nix
    ./../../modules/remote-unlock.nix
    ./../../services/tailscale.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      eh8 = import ./../../modules/home.nix;
    };
  };

  networking.hostName = "sg13chng";
}
