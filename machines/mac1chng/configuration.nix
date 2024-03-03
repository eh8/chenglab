{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./../../modules/mac.nix
    inputs.home-manager.darwinModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      eh8 = {
        imports = [
          ./../../modules/home.nix
          ./../../modules/alacritty.nix
          ./../../modules/1password.nix
          ./../../modules/zsh.nix
        ];
      };
    };
  };

  networking.hostName = "mac1chng";
}
