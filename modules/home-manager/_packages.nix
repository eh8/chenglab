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
      # inspo: https://mynixos.com/nixpkgs/package/azure-cli
      (azure-cli.withExtensions [azure-cli.extensions.k8s-extension])
      bun
      devenv
      doppler
      flyctl
      just
      kubectl
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
