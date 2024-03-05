{
  lib,
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
      asciiquarium
      bat
      btop
      bun
      croc
      duf
      fortune-kind
      genact
      imagemagick
      just
      kopia
      neofetch
      nil
      pandoc
      qrencode
      sops
      tealdeer
      tree
      zola
    ];
  };

  programs = {
    git = {
      enable = true;
      delta = {
        enable = true;
      };
    };
    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "dark_high_contrast";
      };
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    zellij = {
      enable = true;
      settings = {
        theme = "dracula";
      };
    };
    eza.enable = true;
  };

  # Nicely reload system units when changing configs
  # Self-note: nix-darwin seems to luckily ignore this setting
  systemd.user.startServices = "sd-switch";
}
