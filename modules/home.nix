{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home = {
    username = "eh8";
    homeDirectory = lib.mkMerge [
      (lib.mkIf pkgs.stdenv.isLinux "/home/eh8")
      (lib.mkIf pkgs.stdenv.isDarwin "/Users/eh8")
    ];
    stateVersion = "23.11";
    sessionVariables = lib.mkIf (pkgs.stdenv.isDarwin) {
      SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/keys.txt";
    };
    packages = with pkgs; [
      alejandra
      bat
      btop
      croc
      duf
      eza
      fortune-kind
      genact
      just
      kopia
      neofetch
      nil
      sops
      tealdeer
      tree
    ];
  };

  programs.git = {
    enable = true;
    delta = {
      enable = true;
    };
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "dark_high_contrast";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zellij = {
    enable = true;
    settings = {
      theme = "dracula";
    };
  };

  # Nicely reload system units when changing configs
  # Self-note: nix-darwin seems to luckily ignore this setting
  systemd.user.startServices = "sd-switch";
}
