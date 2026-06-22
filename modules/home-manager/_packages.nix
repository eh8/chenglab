{
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
}: let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
  isServer = lib.hasPrefix "svr" osConfig.networking.hostName;
in {
  home = {
    packages = with pkgs;
      [
        asciinema
        asciinema-agg
        asciiquarium-transparent
        cbonsai
        clolcat
        cmatrix
        croc
        curl
        dig
        dust
        dua
        duf
        figlet
        fortune-kind
        gdu
        genact
        glow
        gti
        hyperfine
        imagemagick
        openssl
        jq
        kopia
        neo-cowsay
        nix-tree
        pandoc
        pipes-rs
        poppler-utils
        qrencode
        tree
        wget
      ]
      ++ (
        if !isServer
        then [
          # Below packages are excluded from servers
          # inspo: https://discourse.nixos.org/t/how-to-use-hostname-in-a-path/42612/3
          alejandra
          bun
          docker
          doppler
          just
          gnupg1
          ffmpeg
          k9s
          kubectl
          kubectx
          kubelogin
          kubernetes-helm
          nil
          nixos-rebuild # need for macOS
          nixd # need for language server
          nodejs
          pkgs-unstable.claude-code
          pkgs-unstable.codex
          pkgs-unstable.colima
          python315
          sops
          statix
          stripe-cli
          zola
        ]
        else [
          # Below packages are for servers only
        ]
      );
  };
}
