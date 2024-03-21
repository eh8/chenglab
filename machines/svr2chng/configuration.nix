{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager
    inputs.nixarr.nixosModules.default

    ./hardware-configuration.nix

    ./../../modules/nixos/base.nix
    ./../../modules/nixos/packages.nix
    ./../../modules/nixos/remote-unlock.nix

    ./../../services/tailscale.nix
    ./../../services/netdata.nix
    ./../../services/nixarr.nix
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
        ];
      };
    };
  };

  networking.hostName = "svr2chng";
}
