{
  description = "homelab for eh8";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, home-manager,  ... }:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations = {
      sg13chng = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/configuration.nix
        ];
      };
    };
  };
}