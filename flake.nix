{
  description = "chenglab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixarr = {
      url = "github:rasmus-kirk/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homebrew-cask-fonts = {
      url = "github:homebrew/homebrew-cask-fonts";
      flake = false;
    };

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Enables `nix fmt` at root of repo to format all nix files
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Test bench desktop
    nixosConfigurations = {
      dsk1chng = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./machines/dsk1chng/configuration.nix];
      };
    };

    # Custom NixOS iso
    nixosConfigurations = {
      iso1chng = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        system = "x86_64-linux";
        modules = [
          (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
          ./machines/iso1chng/configuration.nix
        ];
      };
    };

    # M1 Macbook Air
    darwinConfigurations = {
      mac1chng = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./machines/mac1chng/configuration.nix];
      };
    };

    # Server 1
    nixosConfigurations = {
      svr1chng = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./machines/svr1chng/configuration.nix];
      };
    };

    # Server 2
    nixosConfigurations = {
      svr2chng = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./machines/svr2chng/configuration.nix];
      };
    };

    # Server 3
    nixosConfigurations = {
      svr3chng = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./machines/svr3chng/configuration.nix];
      };
    };
  };
}
