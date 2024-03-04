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
    ./../../modules/nixos/base.nix
    ./../../modules/nixos/remote-unlock.nix
    ./../../services/tailscale.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      eh8 = {
        imports = [
          ./../../modules/home-manager/home.nix
          ./../../modules/home-manager/zsh.nix
        ];
      };
    };
  };

  networking.hostName = "dsk1chng";
}
