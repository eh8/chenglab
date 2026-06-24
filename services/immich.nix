{
  config,
  pkgs,
  vars,
  ...
}: {
  imports = [
    ./acme.nix
    ./nginx.nix
  ];

  services = {
    immich = {
      enable = true;
      accelerationDevices = [vars.renderDevice];
      settings = {
        ffmpeg = {
          accel = "vaapi";
          accelDecode = true;
          preferredHwDevice = vars.renderDevice;
        };
        server.externalDomain = "https://immich.${vars.domain}";
      };
    };

    nginx.virtualHosts."immich.${vars.domain}" = {
      forceSSL = true;
      useACMEHost = vars.domain;
      locations."/" = {
        proxyPass = "http://${config.services.immich.host}:${toString config.services.immich.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_read_timeout   600s;
          proxy_send_timeout   600s;
          send_timeout         600s;
        '';
      };
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  users.users.immich.extraGroups = [
    "render"
    "video"
  ];

  chenglab.kopiaBackup.paths = ["/var/lib/immich"];

  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/immich"
    ];
  };
}
