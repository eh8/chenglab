{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    delta = {
      enable = true;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting = {
      enable = true;
    };
    shellAliases = {
      cat = "bat --style=plain --theme=base16 --paging=never ";
      ls = "eza ";
      e = "eza ";
      v = "nvim ";
      sudo = "sudo ";
      ".." = "cd ..";
    };
    # https://discourse.nixos.org/t/zsh-zplug-powerlevel10k-zshrc-is-readonly/30333
    initExtra = ''
      fortune

      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      IdentityAgent ~/.1password/agent.sock
    '';
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home = {
    username = "eh8";
    homeDirectory = "/home/eh8";
    stateVersion = "23.11";
    packages = [
      pkgs.bat
      pkgs.btop
      pkgs.croc
      pkgs.duf
      pkgs.eza
      pkgs.fortune-kind
      pkgs.just
      pkgs.kopia
      pkgs.neofetch
      pkgs.tealdeer
    ];
    file = {
      ".p10k.zsh".source = ../utils/p10k.zsh;
    };
  };
}
