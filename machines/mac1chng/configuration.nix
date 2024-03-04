{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./../../modules/macos/base.nix
    ./../../modules/macos/wallpaper.nix
    inputs.home-manager.darwinModules.home-manager
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
          ./../../modules/home-manager/alacritty.nix
          ./../../modules/home-manager/1password.nix
        ];
      };
    };
  };

  networking.hostName = "mac1chng";
}
