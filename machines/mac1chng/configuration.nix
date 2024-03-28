{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager

    ./../../modules/macos/base.nix
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
          ./../../modules/home-manager/fonts.nix
          ./../../modules/home-manager/alacritty.nix
          ./../../modules/home-manager/1password.nix
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
