{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Import home-manager's bundled NixOS module
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 5;
  };

  time.timeZone = "America/New_York";

  users.mutableUsers = false;
  users.users.eh8 = {
    isNormalUser = true;
    description = "eh8";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIkcgwjYMHqUDnx0JIOSXQ/TN80KEaFvvUWA2qH1AHFC"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
    initialHashedPassword = "$6$CiT7P11BDzbTEXhQ$Cz4pVgUgHtkgNCgjB8r0PQ1Z.jajc6vwuphGjockKnO9e4EOA5Y9Ef3f1PpVYGMXgzvYX1R4Jh8hUo6Ku4J.l0";
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };

  programs.zsh.enable = true;
  programs._1password.enable = true;

  zramSwap.enable = true;

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      # Import your home-manager configuration
      eh8 = import ./home.nix;
    };
  };
}
