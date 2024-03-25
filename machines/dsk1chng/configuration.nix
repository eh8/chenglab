{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager

    ./hardware-configuration.nix

    ./../../modules/nixos/base.nix
    ./../../modules/nixos/packages.nix
    ./../../modules/nixos/desktop.nix
    ./../../modules/nixos/gnome.nix
    ./../../modules/nixos/amdgpu.nix
    ./../../modules/nixos/1password.nix

    ./../../services/tailscale.nix
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
          ./../../modules/home-manager/fonts.nix
          ./../../modules/home-manager/zsh.nix
          ./../../modules/home-manager/alacritty.nix
          ./../../modules/home-manager/1password-agents.nix
          ./../../modules/home-manager/desktop.nix
          ./../../modules/home-manager/gnome.nix
        ];
      };
    };
  };

  networking.hostName = "dsk1chng";
}
