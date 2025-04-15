{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./_acme.nix
    ./_nginx.nix
  ];

  sops.secrets.nextcloud-adminpassfile = {
    owner = "nextcloud";
    group = "nextcloud";
  };

  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      hostName = "cloud.chengeric.com";

      https = true;
      maxUploadSize = "16G";
      configureRedis = true;
      database.createLocally = true;
      # As recommended by admin panel
      phpOptions."opcache.interned_strings_buffer" = "24";

      extraAppsEnable = true;
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) previewgenerator;
      };

      config = {
        adminuser = "admin";
        adminpassFile = config.sops.secrets.nextcloud-adminpassfile.path;
        dbtype = "pgsql";
      };

      settings = {
        defaultPhoneRegion = "US";
        enabledPreviewProviders = [
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
    };

    nginx = {
      virtualHosts = {
        "${config.services.nextcloud.hostName}" = {
          forceSSL = true;
          useACMEHost = "chengeric.com";
        };
      };
    };
  };

  # Need ffmpeg to handle video thumbnails
  environment.systemPackages = with pkgs; [
    ffmpeg
  ];

  sops.secrets."kopia-repository-token" = {};

  systemd = {
    services = {
      "backup-nextcloud" = {
        description = "Backup Nextcloud data with Kopia";
        wantedBy = ["default.target"];
        serviceConfig = {
          User = "root";
          ExecStartPre = "${pkgs.kopia}/bin/kopia repository connect from-config --token-file ${config.sops.secrets."kopia-repository-token".path}";
          ExecStart = "${pkgs.kopia}/bin/kopia snapshot create /fun/nextcloud";
          ExecStartPost = "${pkgs.kopia}/bin/kopia repository disconnect";
        };
      };
    };

    timers = {
      "backup-nextcloud" = {
        description = "Backup Nextcloud data with Kopia";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "*-*-* 4:00:00";
          RandomizedDelaySec = "1h";
        };
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
