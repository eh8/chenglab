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
      eh8 = {
        imports = [
          ./../../modules/home.nix
          ./../../modules/zsh.nix
        ];
      };
    };
  };

  networking.hostName = "dsk1chng";
}
