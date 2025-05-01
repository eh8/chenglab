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
        curl
        dig
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
        openssl
        jdupes
        kopia
        neo-cowsay
        pandoc
        pipes-rs
        poppler_utils
        qrencode
        tree
        wget
        yt-dlp
      ]
      ++ (
        if builtins.substring 0 3 osConfig.networking.hostName != "svr"
        then [
          # Below packages are for personal machines only; excluded from servers
          # inspo: https://discourse.nixos.org/t/how-to-use-hostname-in-a-path/42612/3
          alejandra
          bun
          doppler
          just
          gnupg1
          nil
          nixos-rebuild # need for macOS
          nodejs
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
