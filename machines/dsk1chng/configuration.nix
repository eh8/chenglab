{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos/base.nix
    ./../../modules/nixos/remote-unlock.nix
    ./../../services/tailscale.nix
    # ./../../services/jellyfin.nix
    # ./../../services/nextcloud.nix
    # ./../../services/nginx.nix
    # ./../../services/cloudflared.nix

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
