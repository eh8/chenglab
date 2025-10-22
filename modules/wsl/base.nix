{
  pkgs,
  vars,
  ...
}: {
  imports = [
    ./_packages.nix
  ];

  wsl = {
    enable = true;
    defaultUser = vars.userName;
    # note: disabled auto-generated resolv.conf since default dns results in helm failure
    wslConf.network.generateResolvConf = false;
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  users.users.${vars.userName} = {
    isNormalUser = true;
    description = vars.userName;
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  services.vscode-server.enable = true;
  time.timeZone = "America/New_York";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
