{config, ...}: {
  imports = [
    ./acme.nix
    ./nginx.nix
  ];

  services = {
    immich = {
      enable = true;
      settings.server.externalDomain = "https://immich.chengeric.com";
    };

    nginx.virtualHosts."immich.chengeric.com" = {
      forceSSL = true;
      useACMEHost = "chengeric.com";
      locations."/" = {
        recommendedProxySettings = true;
        proxyPass = "http://${config.services.immich.host}:${toString config.services.immich.port}";
        extraConfig = ''
          client_max_body_size 0;
          proxy_request_buffering off;
        '';
      };
    };
  };

  chenglab.kopiaBackup.paths = ["/var/lib/immich"];

  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/immich"
    ];
  };
}
