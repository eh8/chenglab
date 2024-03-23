{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager

    ./../../modules/macos/base.nix
    ./../../modules/macos/packages.nix
    ./../../modules/macos/wallpaper.nix
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      eh8 = {
        imports = [
          ./../../modules/home-manager/base.nix
          ./../../modules/home-manager/packages.nix
          ./../../modules/home-manager/zsh.nix
          ./../../modules/home-manager/alacritty.nix
          ./../../modules/home-manager/1password-agents.nix
        ];
      };
    };
  };

  networking = {
    hostName = "mac1chng";
    computerName = "mac1chng";
    localHostName = "mac1chng";
  };
}
