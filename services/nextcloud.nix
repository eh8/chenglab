{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./acme.nix
  ];

  sops.secrets.nextcloud-adminpassfile = {};
  sops.secrets.nextcloud-adminpassfile.owner = "nextcloud";
  sops.secrets.nextcloud-adminpassfile.group = "nextcloud";

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
      "OC\\Preview\\HEIC"
      "OC\\Preview\\Movie"
      "OC\\Preview\\MP4"
    ];
  };

  environment.systemPackages = with pkgs; [
    ffmpeg
  ];

  services.nginx = {
    enable = true;
    virtualHosts = {
      "${config.services.nextcloud.hostName}" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
      };
    };
  };

  systemd.services = {
    "nextcloud_all_previews" = {
      description = "Generate all previews";
      wantedBy = ["default.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe config.services.nextcloud.occ} preview:generate-all";
      };
    };
  };

  systemd.services = {
    "nextcloud_previews" = {
      description = "Generate previews";
      wantedBy = ["default.target"];
      serviceConfig = {
        RestartSec = 30;
        ExecStart = "${lib.getExe config.services.nextcloud.occ} preview:pre-generate";
      };
    };
  };

  systemd.timers = {
    "nextcloud_previews" = {
      enable = true;
      description = "Generate previews";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*:0/10";
      };
    };
  };

  fileSystems."/var/lib/nextcloud" = {
    device = "/nix/persist/var/lib/nextcloud";
    fsType = "none";
    options = ["bind"];
  };

  fileSystems."/var/lib/postgresql" = {
    device = "/nix/persist/var/lib/postgresql";
    fsType = "none";
    options = ["bind"];
  };
}
