{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      # fun
      asciiquarium
      cbonsai
      cmatrix
      pipes-rs
      clolcat
      figlet
      fortune-kind
      genact
      gti
      neo-cowsay
      neofetch

      # development
      alejandra
      bun
      cachix
      cloudflared
      devenv
      just
      nil
      nixos-rebuild # need for macos
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
