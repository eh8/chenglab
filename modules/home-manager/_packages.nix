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
      azure-cli
      bun
      devenv
      doppler
      flyctl
      just
      nil
      nixos-rebuild # need for macOS
      nodejs
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
      jdupes
      kopia
      pandoc
      poppler_utils
      qrencode
      tree
      yt-dlp
    ];
  };
}
