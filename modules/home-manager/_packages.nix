{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      # fun
      asciiquarium
      cbonsai
      clolcat
      cmatrix
      figlet
      fortune-kind
      genact
      gti
      neo-cowsay
      neofetch
      pipes-rs

      # development
      alejandra
      bun
      cloudflared
      devenv
      just
      nil
      nixos-rebuild # need for macos
      poetry
      pandoc
      sops
      statix
      zola

      # quality of life
      bat
      bind
      btop
      croc
      du-dust
      dua
      duf
      gallery-dl
      gdu
      imagemagick
      kopia
      qrencode
      tree
      yt-dlp
    ];
  };
}
