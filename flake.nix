{
  description = "homelab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    sops-nix.url = "github:Mic92/sops-nix";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      sg13chng = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./machines/sg13chng/configuration.nix];
      };
    };
    darwinConfigurations = {
      mac1chng = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./machines/mac1chng/configuration.nix];
      };
    };
  };
}
