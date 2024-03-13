{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ./../../modules/nixos/base.nix
    ./../../modules/nixos/remote-unlock.nix
    ./../../modules/nixos/secondary-drive.nix

    ./../../services/tailscale.nix
    ./../../services/filerun.nix

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

  networking.hostName = "svr1chng";
}
