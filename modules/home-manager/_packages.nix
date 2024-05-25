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
      pipes-rs

      # development
      alejandra
      bun
      devenv
      doppler
      flyctl
      just
      nil
      nixos-rebuild # need for macOS
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
      pandoc
      qrencode
      tree
      yt-dlp
    ];
  };
}
