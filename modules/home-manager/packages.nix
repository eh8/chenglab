{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      alejandra
      asciiquarium
      bat
      bind
      btop
      bun
      cachix
      clolcat
      cloudflared
      croc
      du-dust
      dua
      duf
      figlet
      fortune-kind
      gallery-dl
      gdu
      genact
      imagemagick
      just
      kopia
      neo-cowsay
      neofetch
      nil
      nixos-rebuild # need for macos
      pandoc
      qrencode
      sops
      statix
      tree
      yt-dlp
      zola
    ];
  };
}
