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
          # Below packages are for personal machines only; excluded from servers
          # inspo: https://discourse.nixos.org/t/how-to-use-hostname-in-a-path/42612/3
          alejandra
          bun
          doppler
          just
          gnupg1
          ffmpeg
          nil
          nixos-rebuild # need for macOS
          nixd # need for language server
          nodejs
          pkgs-unstable.codex
          sops
          statix
          stripe-cli
          zola
        ]
        else [
          # Below packages are for servers only; excluded from personal machines
        ]
      );
  };
}
