{
  pkgs,
  osConfig,
  ...
}: {
  home = {
    packages = with pkgs;
      [
        asciiquarium
        bat
        bind
        btop
        cbonsai
        clolcat
        cmatrix
        croc
        du-dust
        dua
        duf
        figlet
        fortune-kind
        gallery-dl
        gdu
        genact
        gti
        htop
        hyperfine
        imagemagick
        jdupes
        kopia
        neo-cowsay
        pandoc
        pipes-rs
        poppler_utils
        qrencode
        tree
        yt-dlp
      ]
      # Below packages are for development and therefore excluded from servers
      # inspo: https://discourse.nixos.org/t/how-to-use-hostname-in-a-path/42612/3
      ++ (
        if builtins.substring 0 3 osConfig.networking.hostName != "svr"
        then [
          alejandra
          bun
          doppler
          flyctl
          just
          nil
          nixos-rebuild # need for macOS
          nodejs
          sops
          statix
          stripe-cli
          wrangler
          zola
        ]
        else []
      );
  };
}
