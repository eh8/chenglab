{...}: {
  imports = [
    ./acme.nix
  ];

  nixarr = {
    enable = true;

    mediaDir = "/fun/media";
    stateDir = "/var/lib/nixarr/state";

    jellyfin = {
      enable = true;
      expose.https = {
        enable = true;
        domainName = "waffle.chengeric.com";
        acmeMail = "admin+acme@chengeric.com"; # Required for ACME-bot
      };
    };

    sonarr.enable = true;
    radarr.enable = true;
    prowlarr.enable = true;
  };

  fileSystems."/var/lib/nixarr" = {
    device = "/nix/persist/var/lib/nixarr";
    fsType = "none";
    options = ["bind"];
  };

  # services.nginx = {
  #   enable = true;
  #   recommendedProxySettings = true;
  #   recommendedTlsSettings = true;
  #   virtualHosts = {
  #     "waffle.chengeric.com" = {
  #       forceSSL = true;
  #       useACMEHost = "chengeric.com";
  #       locations."/" = {
  #         proxyPass = "http://127.0.0.1:8096";
  #       };
  #     };
  #   };
  # };
}
