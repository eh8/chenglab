{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./acme.nix
    ./nginx.nix
  ];

  sops.secrets.nextcloud-adminpassfile = {
    owner = "nextcloud";
    group = "nextcloud";
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    hostName = "cloud.chengeric.com";
    https = true;
    maxUploadSize = "16G";
    configureRedis = true;
    database.createLocally = true;
    config.adminuser = "admin";
    config.dbtype = "pgsql";
    config.adminpassFile = config.sops.secrets.nextcloud-adminpassfile.path;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) previewgenerator;
    };
    extraAppsEnable = true;
    # As recommended by admin panel
    phpOptions."opcache.interned_strings_buffer" = "24";
    settings.defaultPhoneRegion = "US";
    settings.enabledPreviewProviders = [
      "OC\\Preview\\BMP"
      "OC\\Preview\\GIF"
      "OC\\Preview\\JPEG"
      "OC\\Preview\\Krita"
      "OC\\Preview\\MarkDown"
      "OC\\Preview\\MP3"
      "OC\\Preview\\OpenDocument"
      "OC\\Preview\\PNG"
      "OC\\Preview\\TXT"
      "OC\\Preview\\XBitmap"
      # Not included by default
      "OC\\Preview\\HEIC"
      "OC\\Preview\\Movie"
      "OC\\Preview\\MP4"
    ];
  };

  # Need ffmpeg to handle video thumbnails
  environment.systemPackages = with pkgs; [
    ffmpeg
  ];

  services.nginx = {
    virtualHosts = {
      "${config.services.nextcloud.hostName}" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
      };
    };
  };

  # This takes prohibitively long, so be careful when running it
  # systemd.services = {
  #   "nextcloud-generate-all-previews" = {
  #     description = "Generate all previews";
  #     wantedBy = ["default.target"];
  #     serviceConfig = {
  #       Type = "oneshot";
  #       ExecStart = "${lib.getExe config.services.nextcloud.occ} preview:generate-all";
  #     };
  #   };
  # };

  systemd.services = {
    "nextcloud-generate-previews" = {
      description = "Generate previews";
      wantedBy = ["default.target"];
      serviceConfig = {
        RestartSec = 30;
        ExecStart = "${lib.getExe config.services.nextcloud.occ} preview:pre-generate";
      };
    };
  };

  systemd.timers = {
    "nextcloud-generate-previews" = {
      enable = true;
      description = "Generate previews";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*:0/10";
      };
    };
  };

  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/nextcloud"
      "/var/lib/postgresql"
    ];
  };
}
